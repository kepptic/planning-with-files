#!/bin/bash
# Check if all phases in task_plan.md are complete
# Exit 0 if complete, exit 1 if incomplete
# Used by Stop hook to verify task completion

set -e

PLAN_FILE="${1:-task_plan.md}"

if [ ! -f "$PLAN_FILE" ]; then
    echo "ERROR: $PLAN_FILE not found"
    echo "Cannot verify completion without a task plan."
    exit 1
fi

echo "=== Task Completion Check ==="
echo ""

# Count phases by status
TOTAL=$(grep -c "### Phase" "$PLAN_FILE" 2>/dev/null || echo "0")
COMPLETE=$(grep -c "Status:\*\* complete" "$PLAN_FILE" 2>/dev/null || echo "0")
IN_PROGRESS=$(grep -c "Status:\*\* in_progress" "$PLAN_FILE" 2>/dev/null || echo "0")
PENDING=$(grep -c "Status:\*\* pending" "$PLAN_FILE" 2>/dev/null || echo "0")

echo "Total phases:   $TOTAL"
echo "Complete:       $COMPLETE"
echo "In progress:    $IN_PROGRESS"
echo "Pending:        $PENDING"
echo ""

# Check completion
if [ "$COMPLETE" -eq "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    echo "ALL PHASES COMPLETE"
    echo ""
    echo "5-Question Reboot Test:"
    echo "  Where am I? → All phases done"
    echo "  Where am I going? → Delivery"
    echo "  What's the goal? → Check task_plan.md"
    echo "  What have I learned? → See findings.md"
    echo "  What have I done? → See progress.md"
    exit 0
else
    echo "TASK NOT COMPLETE"
    echo ""
    echo "Incomplete phases:"
    grep -B1 "Status:\*\* pending\|Status:\*\* in_progress" "$PLAN_FILE" | grep "### Phase" || echo "  (none found)"
    echo ""
    echo "Do not stop until all phases are complete."
    exit 1
fi
