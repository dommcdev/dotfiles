#!/usr/bin/env bash
set -e

# Ensure we're in the script's directory
cd "$(dirname "$0")"

# Find git root
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Target file relative to repo root
TARGET_FILE="todo.txt"

if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: File $TARGET_FILE not found in $REPO_ROOT."
    exit 1
fi

echo "Analyzing git history for $TARGET_FILE..."
echo "This may take a moment..."

# Generate data in JSON format
TEMP_DATA=$(mktemp)
echo "const historyData = [" > "$TEMP_DATA"

# Get history: hash and date
# NOTE: We do NOT use --reverse because it breaks --follow in some git versions.
# We will get newest to oldest, and reverse it in JS.
git log --follow --format="%h %ad" --date=short -- "$TARGET_FILE" | while read -r hash date; do
    # Capture content safely
    if content=$(git show "$hash:$TARGET_FILE" 2>/dev/null); then
        # Count non-blank lines
        count=$(echo "$content" | grep -cve '^\s*$' || echo 0)
        echo "  { date: '$date', count: $count }," >> "$TEMP_DATA"
    fi
done

echo "];" >> "$TEMP_DATA"

# Generate commit frequency data
echo "const commitData = [" >> "$TEMP_DATA"
# Get all commit dates for the ENTIRE REPO, count occurrences per day
# We use --all to capture work across all branches, reflecting true "productivity"
git log --all --format="%ad" --date=short | sort | uniq -c | while read -r count date; do
    echo "  { date: '$date', count: $count }," >> "$TEMP_DATA"
done
echo "];" >> "$TEMP_DATA"

# Output file
OUTPUT_HTML="docs/productivity.html"

# Create the HTML file
cat <<EOF > "$OUTPUT_HTML"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productivity Visualization</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns"></script>
    <style>
        :root {
            --bg-color: #1e1e2e; /* Catppuccin Mocha Base */
            --card-bg: #313244; /* Catppuccin Mocha Surface0 */
            --text-color: #cdd6f4; /* Catppuccin Mocha Text */
            --accent-color: #89b4fa; /* Catppuccin Mocha Blue */
            --accent-color-2: #a6e3a1; /* Catppuccin Mocha Green */
            --grid-color: #45475a; /* Catppuccin Mocha Surface1 */
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        h1 {
            font-weight: 700;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, #89b4fa, #f5c2e7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2.5rem;
            letter-spacing: -0.02em;
        }

        .charts-wrapper {
            display: flex;
            flex-direction: column;
            gap: 2rem;
            width: 100%;
            max-width: 1000px;
        }

        .chart-container {
            position: relative;
            width: 100%;
            background-color: var(--card-bg);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--text-color);
            opacity: 0.9;
        }

        canvas {
            width: 100% !important;
            height: 400px !important;
        }

        .footer {
            margin-top: 3rem;
            font-size: 0.9rem;
            opacity: 0.6;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <h1>Productivity Analysis</h1>
    
    <div class="charts-wrapper">
        <div class="chart-container">
            <div class="chart-title">Todo List Growth</div>
            <canvas id="historyChart"></canvas>
        </div>

        <div class="chart-container">
            <div class="chart-title">Commits Per Day (Entire Repo)</div>
            <canvas id="commitChart"></canvas>
        </div>
    </div>

    <div class="footer">
        Generated on $(date +"%Y-%m-%d %H:%M")
    </div>

    <script>
        $(cat "$TEMP_DATA")

        // Reverse history data to be chronological (oldest to newest)
        historyData.reverse();
        // Commit data is already sorted by date due to 'sort' command

        // Common chart options
        const commonOptions = {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index',
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    backgroundColor: '#181825',
                    titleColor: '#cdd6f4',
                    bodyColor: '#a6adc8',
                    borderColor: '#45475a',
                    borderWidth: 1,
                    padding: 10,
                    displayColors: false,
                }
            },
            scales: {
                x: {
                    type: 'time',
                    time: {
                        unit: 'month', 
                        displayFormats: {
                            month: 'MMM yyyy'
                        }
                    },
                    grid: {
                        color: '#45475a',
                        drawBorder: false
                    },
                    ticks: {
                        color: '#a6adc8'
                    }
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        color: '#45475a',
                        drawBorder: false
                    },
                    ticks: {
                        color: '#a6adc8'
                    }
                }
            }
        };

        // --- History Chart ---
        const ctxHistory = document.getElementById('historyChart').getContext('2d');
        const gradientHistory = ctxHistory.createLinearGradient(0, 0, 0, 400);
        gradientHistory.addColorStop(0, 'rgba(137, 180, 250, 0.5)'); // Blue
        gradientHistory.addColorStop(1, 'rgba(137, 180, 250, 0.0)');

        new Chart(ctxHistory, {
            type: 'line',
            data: {
                labels: historyData.map(d => d.date),
                datasets: [{
                    label: 'Lines of Code',
                    data: historyData.map(d => d.count),
                    borderColor: '#89b4fa',
                    backgroundColor: gradientHistory,
                    borderWidth: 3,
                    pointBackgroundColor: '#1e1e2e',
                    pointBorderColor: '#89b4fa',
                    pointBorderWidth: 2,
                    pointRadius: 1, 
                    pointHoverRadius: 6,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                ...commonOptions,
                plugins: {
                    ...commonOptions.plugins,
                    tooltip: {
                        ...commonOptions.plugins.tooltip,
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y + ' lines';
                            }
                        }
                    }
                }
            }
        });

        // --- Commit Chart ---
        const ctxCommit = document.getElementById('commitChart').getContext('2d');
        const gradientCommit = ctxCommit.createLinearGradient(0, 0, 0, 400);
        gradientCommit.addColorStop(0, 'rgba(166, 227, 161, 0.5)'); // Green
        gradientCommit.addColorStop(1, 'rgba(166, 227, 161, 0.0)');

        new Chart(ctxCommit, {
            type: 'bar',
            data: {
                labels: commitData.map(d => d.date),
                datasets: [{
                    label: 'Commits',
                    data: commitData.map(d => d.count),
                    borderColor: '#a6e3a1',
                    backgroundColor: gradientCommit,
                    borderWidth: 2,
                    borderRadius: 4,
                    borderSkipped: false,
                }]
            },
            options: {
                ...commonOptions,
                plugins: {
                    ...commonOptions.plugins,
                    tooltip: {
                        ...commonOptions.plugins.tooltip,
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y + ' commits';
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
EOF

rm "$TEMP_DATA"

echo "Visualization generated at $(pwd)/$OUTPUT_HTML"

# Try to open in browser if on macOS or Linux
if command -v open > /dev/null; then
    open "$OUTPUT_HTML"
elif command -v xdg-open > /dev/null; then
    xdg-open "$OUTPUT_HTML" > /dev/null 2>&1 &
else
    echo "Please open $(pwd)/$OUTPUT_HTML in your web browser."
fi
