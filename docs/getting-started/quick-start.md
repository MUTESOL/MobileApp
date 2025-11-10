# Quick Start Guide

Get up and running with StackSave in just a few minutes!

## Overview

This guide will walk you through:
1. Installing and launching StackSave
2. Connecting your crypto wallet
3. Creating your first savings goal
4. Making your first deposit

**Estimated time:** 5-10 minutes

## Step 1: Install StackSave

### For Users
Download StackSave from:
- **iOS**: App Store (coming soon)
- **Android**: Google Play Store (coming soon)
- **Development**: See [Installation Guide](installation.md)

### For Developers
```bash
git clone https://github.com/MUT-TANT/MobileApp.git
cd stacksave
flutter pub get
flutter run
```

## Step 2: Launch the App

1. Open StackSave on your device
2. You'll see a splash screen with the StackSave logo
3. After a brief loading screen, you'll reach the welcome screen

## Step 3: Connect Your Wallet

StackSave requires a crypto wallet to function. Don't have one? See [Wallet Setup](#wallet-setup) below.

### Connection Process

1. On the welcome screen, tap **"Connect Wallet"**

2. A QR code will appear along with a connection URI

3. **On Mobile**:
   - Tap the wallet icon or "Open in Wallet" button
   - Your wallet app will open automatically
   - Approve the connection request

4. **On Desktop** (using mobile wallet):
   - Open your wallet app on your phone
   - Scan the QR code from the app
   - Approve the connection request

5. Once approved, you'll see:
   - ✅ Connected status
   - Your wallet address (shortened)
   - Access to the home screen

For detailed instructions, see [Connecting Your Wallet](connecting-wallet.md).

## Step 4: Explore the Home Screen

After connecting, you'll see the main dashboard with:

- **Header**: StackSave logo and notifications bell
- **Streak Counter**: Your daily savings streak (🔥)
- **Total Savings**: Your combined savings across all goals
- **Goals Section**: List of your active savings goals
- **Quick Actions**: Floating action button (+) for common tasks
- **Bottom Navigation**: Switch between Home, Portfolio, and Profile

## Step 5: Create Your First Goal

Let's create a savings goal!

1. Tap the **floating (+) button** at the bottom right

2. Select **"Add Goal"** from the menu

3. Fill in the goal details:
   - **Goal Name**: e.g., "Vacation Fund"
   - **Target Amount**: e.g., 1.5 ETH
   - **Deadline**: Select a target date
   - **Category**: Choose an icon (car, vacation, etc.)

4. Tap **"Create Goal"**

5. Your goal appears on the home screen with:
   - Progress bar (starting at 0%)
   - Amount saved / Target amount
   - Days remaining

For more details, see [Creating Your First Goal](first-goal.md).

## Step 6: Make Your First Deposit

Now let's add funds to your goal:

1. Tap on your newly created goal

2. Tap the **"Add Savings"** button

3. Enter the amount to deposit (in ETH or your chosen currency)

4. Review the transaction details:
   - Amount
   - Gas fees
   - Total cost

5. Tap **"Confirm"**

6. Approve the transaction in your wallet app

7. Wait for blockchain confirmation (usually 30-60 seconds)

8. See your progress bar update! 🎉

## You're All Set! 🚀

Congratulations! You've:
- ✅ Connected your wallet
- ✅ Created a savings goal
- ✅ Made your first deposit

## What's Next?

### Explore More Features
- **Portfolio**: View all your goals and overall progress
- **Notifications**: Set up reminders to stay on track
- **Profile**: Customize your profile and settings
- **Withdrawals**: Learn how to withdraw funds when needed

### Learn the Platform
- [Features Overview](../features/overview.md) - Explore all features
- [Wallet Integration](../web3/wallet-connect.md) - Deep dive into Web3
- [Managing Goals](../features/savings-goals.md) - Goal management tips

### Get Help
- [FAQ](../resources/faq.md) - Common questions
- [Troubleshooting](../resources/troubleshooting.md) - Solve issues
- Community Discord (coming soon)

## Quick Tips for Success

### 🎯 Set Realistic Goals
Start with small, achievable goals to build momentum.

### 📅 Use Deadlines
Goals with deadlines are more likely to be achieved.

### 🔔 Enable Notifications
Reminders help you stay consistent with deposits.

### 🔥 Build Your Streak
Deposit regularly to build and maintain your savings streak.

### 📊 Track Progress
Regularly check your portfolio to stay motivated.

## Common First-Time Questions

**Q: Do I need cryptocurrency?**
A: Yes, StackSave works with crypto wallets. You'll need some ETH (or supported tokens) to start saving.

**Q: Is my money safe?**
A: Yes! StackSave never holds your funds. Everything stays in your wallet under your control.

**Q: Can I withdraw anytime?**
A: Absolutely! You have complete control and can withdraw whenever you want.

**Q: What if I don't reach my goal?**
A: No problem! Goals are flexible. You can extend the deadline, adjust the target, or withdraw what you've saved.

**Q: Are there fees?**
A: StackSave itself is free. You only pay standard blockchain gas fees for transactions.

## Wallet Setup

### Don't Have a Wallet Yet?

Here's how to get started:

#### Recommended Wallets
- **MetaMask** - Most popular, easy to use
- **Trust Wallet** - Mobile-focused, user-friendly
- **Rainbow** - Beautiful UI, great for beginners

#### Setup Steps
1. Download your chosen wallet app
2. Create a new wallet (follow app instructions)
3. **IMPORTANT**: Safely store your recovery phrase
4. Add some ETH to your wallet (via exchange or purchase)
5. Return to StackSave and connect!

---

**Need help?** Check out our [detailed guides](../getting-started/connecting-wallet.md) or [FAQ](../resources/faq.md).
