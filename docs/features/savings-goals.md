# Savings Goals

Savings Goals are the core feature of StackSave, allowing you to create targeted savings objectives with specific amounts and deadlines.

## What is a Savings Goal?

A Savings Goal is a defined target amount you want to save, optionally with a deadline. Each goal is tracked independently and stored on the blockchain.

### Goal Components

Each savings goal consists of:

- **Name**: A descriptive name for your goal (e.g., "Emergency Fund", "New Car")
- **Target Amount**: The amount you want to save (in USDC)
- **Current Amount**: How much you've saved so far
- **Deadline**: Optional target date to reach your goal
- **Category**: Goal type (Emergency, Vacation, Investment, etc.)
- **Created Date**: When the goal was created

---

## Creating a Savings Goal

### Step 1: Navigate to Add Goal

From the home screen, tap the "Add New Goal" button or the "+" icon.

### Step 2: Fill in Goal Details

```
Goal Name: Summer Vacation
Target Amount: 5000 USDC
Deadline: 2025-08-01
Category: Vacation
```

### Step 3: Confirm and Create

Review your goal details and tap "Create Goal". You'll need to:

1. Confirm the transaction in your wallet
2. Pay a small gas fee for the on-chain transaction
3. Wait for transaction confirmation

### Step 4: Start Saving

Once created, you can start making deposits to your goal!

---

## Managing Savings Goals

### Viewing Your Goals

**Home Screen**:
- All active goals are displayed as cards
- See progress percentage
- View remaining amount to reach target
- Quick access to deposit or withdraw

**Goal Details**:
Tap on any goal to view:
- Detailed progress information
- Transaction history
- Time remaining until deadline
- Savings rate and projections

### Making Deposits

1. **From Home Screen**: Tap the goal card
2. **Enter Amount**: Specify deposit amount in USDC
3. **Confirm**: Approve transaction in your wallet
4. **Track**: Transaction appears in goal history

```dart
// Example deposit flow
final amount = 100.0; // 100 USDC
await walletService.depositToGoal(goalId, amount);
```

### Editing Goals

You can modify certain goal properties:

**Editable**:
- Goal name
- Target amount (can increase or decrease)
- Deadline
- Category

**Not Editable**:
- Created date
- Goal ID
- Transaction history

**To Edit**:
1. Open goal details
2. Tap edit icon
3. Modify desired fields
4. Save changes (may require transaction)

### Deleting Goals

To delete a goal:

1. **Withdraw all funds** first (if any)
2. Open goal details
3. Tap "Delete Goal"
4. Confirm deletion

⚠️ **Warning**: Deleting a goal removes it from your list but transaction history remains on-chain.

---

## Goal Categories

Choose from predefined categories or create custom ones:

### Predefined Categories

| Category | Icon | Description |
|----------|------|-------------|
| Emergency Fund | 🚨 | Unexpected expenses and emergencies |
| Vacation | ✈️ | Travel and holiday savings |
| Education | 🎓 | Tuition, courses, and learning |
| Home | 🏠 | Home purchase or renovation |
| Car | 🚗 | Vehicle purchase or maintenance |
| Wedding | 💒 | Wedding expenses |
| Investment | 📈 | Investment capital |
| Retirement | 🏖 | Long-term retirement savings |
| Gift | 🎁 | Gifts for others |
| Other | ⭐ | Custom savings goals |

### Custom Categories

Create your own category by selecting "Other" and providing a custom name.

---

## Goal Progress Tracking

### Progress Indicators

**Visual Elements**:
- **Progress Bar**: Shows percentage completed
- **Amount Saved**: Current vs. target amount
- **Days Remaining**: Countdown to deadline
- **Savings Rate**: Average deposits per week/month

**Example Display**:
```
Emergency Fund
$3,500 / $10,000 (35%)
━━━━━━━━━━━━━━━━━━━━
📅 125 days remaining
📊 Saving $52/week on average
```

### Goal States

Goals can be in different states:

| State | Description | Actions Available |
|-------|-------------|-------------------|
| Active | In progress, not reached target | Deposit, Withdraw, Edit |
| Completed | Target reached | Withdraw, Archive |
| Overdue | Past deadline, target not reached | Deposit, Extend deadline |
| Archived | Completed and archived | View only |

---

## Advanced Features

### Goal Milestones

Set intermediate milestones to stay motivated:

```
Goal: $10,000 Emergency Fund
├── 25% - $2,500 ✅ Reached!
├── 50% - $5,000 ⏳ In progress
├── 75% - $7,500
└── 100% - $10,000
```

Receive notifications when you reach each milestone!

### Goal Projections

Based on your savings rate, StackSave predicts when you'll reach your goal:

```
Current Rate: $200/month
At this rate, you'll reach your goal in:
🎯 8 months (Jan 2026)

To meet your deadline (Aug 2025):
💡 Save $833/month
```

### Goal Analytics

View detailed analytics for each goal:

- **Deposit Frequency**: How often you deposit
- **Average Deposit**: Typical deposit amount
- **Largest Deposit**: Biggest single deposit
- **Total Deposits**: Number of deposits made
- **Time to Goal**: Estimated completion date

---

## Best Practices

### 💡 Tips for Success

**1. Start Small**
- Begin with achievable targets
- Build confidence with early wins
- Gradually increase goal amounts

**2. Set Realistic Deadlines**
- Consider your income and expenses
- Leave buffer time for unexpected events
- Don't pressure yourself too much

**3. Regular Deposits**
- Consistency beats large occasional deposits
- Set up reminders to deposit regularly
- Even small amounts add up over time

**4. Prioritize Goals**
- Emergency fund should be first priority
- Focus on 1-3 goals at a time
- Complete smaller goals for motivation

**5. Review and Adjust**
- Monthly review of progress
- Adjust targets if circumstances change
- Celebrate milestones!

### ❌ Common Mistakes to Avoid

- **Overambitious Targets**: Setting unrealistic goals leads to frustration
- **Too Many Goals**: Spreading savings too thin
- **No Emergency Fund**: Always prioritize emergency savings first
- **Ignoring Deadlines**: Set meaningful deadlines to stay motivated
- **Withdrawing Too Early**: Only withdraw when truly necessary

---

## Goal Examples

### Example 1: Emergency Fund
```
Name: Emergency Fund
Target: $5,000
Deadline: 12 months
Strategy: $417/month
Purpose: 3 months of living expenses
```

### Example 2: Vacation Savings
```
Name: Europe Trip 2025
Target: $3,000
Deadline: 6 months
Strategy: $500/month
Purpose: 2-week European vacation
```

### Example 3: Investment Capital
```
Name: Crypto Investment
Target: $10,000
Deadline: None (ongoing)
Strategy: Deposit excess income
Purpose: Build investment portfolio
```

---

## Transaction History

Each goal maintains a complete transaction history:

### Viewing History

1. Open goal details
2. Tap "Transaction History"
3. View all deposits and withdrawals

### Transaction Details

Each transaction shows:
- **Type**: Deposit or Withdrawal
- **Amount**: Transaction amount
- **Date**: When it occurred
- **Transaction Hash**: Blockchain transaction ID
- **Status**: Confirmed, Pending, Failed

### Exporting History

Export your transaction history:
- CSV format for spreadsheets
- PDF for record-keeping
- Blockchain explorer link

---

## Smart Contract Integration

Goals are managed by smart contracts on the blockchain.

### On-Chain Storage

Each goal is stored as:
```solidity
struct SavingsGoal {
    string name;
    uint256 targetAmount;
    uint256 currentAmount;
    uint256 deadline;
    address owner;
    bool active;
}
```

### Security

- **Non-custodial**: You always control your funds
- **Transparent**: All transactions visible on-chain
- **Immutable**: Transaction history cannot be altered
- **Audited**: Smart contracts are security audited

---

## Troubleshooting

### Goal Not Appearing

**Solution**:
1. Pull to refresh on home screen
2. Check wallet connection
3. Verify transaction was confirmed
4. Check correct network is selected

### Deposit Failed

**Possible Causes**:
- Insufficient USDC balance
- Not enough gas fees
- Network congestion
- Transaction rejected in wallet

**Solution**:
1. Check USDC and native token balance
2. Increase gas fee
3. Try again during off-peak hours
4. Ensure wallet is unlocked

### Can't Edit Goal

**Possible Reasons**:
- Goal is archived
- Smart contract restriction
- Pending transaction

**Solution**:
- Unarchive goal first
- Wait for pending transactions
- Check goal status

---

## FAQ

**Q: How many goals can I create?**
A: Unlimited! Create as many as you need.

**Q: Can I have the same goal name twice?**
A: Yes, but we recommend unique names for clarity.

**Q: What happens when I reach my goal?**
A: You'll receive a notification and the goal is marked as completed. You can withdraw funds or keep saving.

**Q: Can I transfer funds between goals?**
A: Not directly. You need to withdraw from one goal and deposit to another.

**Q: Is there a minimum goal amount?**
A: No minimum, but consider gas fees for small amounts.

**Q: What if I miss my deadline?**
A: No penalty. You can extend the deadline or continue saving without one.

---

## Next Steps

- [Portfolio Management](portfolio.md) - View all goals together
- [Withdrawals](withdrawals.md) - Learn how to withdraw funds
- [Notifications](notifications.md) - Set up progress alerts

---

Need help? Check out the [Troubleshooting Guide](../resources/troubleshooting.md) or [FAQ](../resources/faq.md).
