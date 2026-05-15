import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String readTime;
  final String difficulty;
  final String body;
  final List<String> keyTakeaways;

  const Lesson({
    required this.id,
    required this.title,
    required this.readTime,
    required this.difficulty,
    required this.body,
    required this.keyTakeaways,
  });
}

class LessonCategory {
  final String id;
  final String title;
  final String emoji;
  final Color color;
  final List<Lesson> lessons;

  const LessonCategory({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.lessons,
  });
}

const List<LessonCategory> lessonCategories = [
  LessonCategory(
    id: 'basics',
    title: 'Crypto Basics',
    emoji: '🪙',
    color: Color(0xFF0F766E),
    lessons: [
      Lesson(
        id: 'basics_1',
        title: 'What is Cryptocurrency?',
        readTime: '3 min read',
        difficulty: 'Beginner',
        body: '''Cryptocurrency is a type of digital or virtual currency that uses cryptography for security. Unlike traditional currencies issued by governments (called fiat currencies), cryptocurrencies operate on decentralized networks — meaning no single bank or government controls them.

The word "crypto" comes from cryptography, the science of securing information. Cryptocurrencies use advanced math to secure transactions and control the creation of new units.

Bitcoin, created in 2009, was the first cryptocurrency. Since then, thousands of others have been created — including Ethereum, Litecoin, and many more. Each one operates on its own set of rules and technology.

**How does it work?**

When you send cryptocurrency to someone, the transaction is broadcast to a network of computers. These computers verify the transaction using complex math and record it in a shared ledger called the blockchain. Once recorded, the transaction cannot be changed or reversed.

**Why do people use it?**

People use cryptocurrency for many reasons: to send money across borders quickly and cheaply, as an investment, to protect savings from inflation, or simply because they believe in decentralized financial systems that don't rely on banks.''',
        keyTakeaways: [
          'Cryptocurrency is digital money secured by cryptography.',
          'It runs on decentralized networks — no bank or government controls it.',
          'Bitcoin was the first cryptocurrency, launched in 2009.',
          'Transactions are recorded on a public ledger called the blockchain.',
          'It can be used for payments, investment, or storing value.',
        ],
      ),
      Lesson(
        id: 'basics_2',
        title: 'What is Blockchain?',
        readTime: '4 min read',
        difficulty: 'Beginner',
        body: '''A blockchain is a special kind of database. Instead of storing data in a central location (like a bank's server), a blockchain stores data across thousands of computers at the same time — making it nearly impossible to hack or alter.

**How it works — block by block**

Data is grouped into "blocks." Each block contains a set of transactions, a timestamp, and a unique code called a "hash." It also contains the hash of the previous block — this is what links the blocks together into a "chain."

If someone tried to change a transaction in an old block, that block's hash would change. This would break the link to every block that came after it, and the network would immediately reject the change. This is what makes blockchains tamper-proof.

**Who maintains the blockchain?**

Thousands of computers (called "nodes") each hold a full copy of the blockchain and constantly check each other's records. When a new transaction happens, the majority of nodes must agree it's valid before it's added. This process is called "consensus."

**Public vs Private blockchains**

Bitcoin and Ethereum use public blockchains — anyone can view all transactions. Some companies use private blockchains where access is restricted to specific participants.

**Beyond cryptocurrency**

Blockchains aren't just for money. They can store any kind of data — medical records, supply chain information, voting records, and more. Many industries are exploring blockchain to increase transparency and reduce fraud.''',
        keyTakeaways: [
          'A blockchain is a decentralized database shared across thousands of computers.',
          'Data is stored in linked "blocks" — altering one breaks the entire chain.',
          'Thousands of nodes verify each transaction, making fraud extremely difficult.',
          'Bitcoin and Ethereum blockchains are public — anyone can view them.',
          'Blockchain technology has uses beyond cryptocurrency.',
        ],
      ),
      Lesson(
        id: 'basics_3',
        title: 'How do Crypto Wallets Work?',
        readTime: '3 min read',
        difficulty: 'Beginner',
        body: '''A crypto wallet doesn't actually store your cryptocurrency — your coins always live on the blockchain. What a wallet stores are your "keys": a public key and a private key.

**Public key = your address**

Your public key is like your bank account number. You share it with others so they can send you cryptocurrency. It's safe to share publicly.

**Private key = your password**

Your private key is like the PIN to your account — but much more powerful. Anyone with your private key can access and spend your funds. Never share it with anyone, never store it online, and never lose it. If you lose your private key with no backup, your funds are gone forever.

**Types of wallets**

- **Hot wallets** (connected to the internet): Apps like this one, browser extensions, or exchange accounts. Convenient for everyday use but less secure.
- **Cold wallets** (offline): Hardware devices like a USB stick that store your keys offline. More secure, harder to hack, but less convenient.
- **Custodial vs Non-custodial**: A custodial wallet (like an exchange) holds your keys for you. Non-custodial means you hold your own keys — and full responsibility.

**Seed phrase**

When you create a new wallet, you're often given a "seed phrase" — 12 or 24 random words. This phrase can recover your entire wallet if your device is lost. Write it down on paper and store it somewhere safe. Never take a photo of it or store it digitally.''',
        keyTakeaways: [
          'Wallets store your keys, not your coins — coins live on the blockchain.',
          'Public key = your address (safe to share). Private key = your password (never share).',
          'Losing your private key with no backup means losing your funds permanently.',
          'Hot wallets are convenient; cold wallets are more secure.',
          'Your seed phrase can recover your wallet — protect it like cash.',
        ],
      ),
    ],
  ),
  LessonCategory(
    id: 'bitcoin',
    title: 'Bitcoin',
    emoji: '₿',
    color: Color(0xFFF59E0B),
    lessons: [
      Lesson(
        id: 'btc_1',
        title: 'What is Bitcoin?',
        readTime: '4 min read',
        difficulty: 'Beginner',
        body: '''Bitcoin (BTC) is the world's first and most well-known cryptocurrency. It was created in 2009 by an anonymous person (or group) using the name Satoshi Nakamoto, who published a paper describing a "peer-to-peer electronic cash system."

**The core idea**

Before Bitcoin, sending money digitally required a trusted third party — like a bank or PayPal — to verify that you actually had the money and hadn't already spent it. Satoshi's breakthrough was solving the "double-spend problem" without needing a trusted third party, using the blockchain instead.

**Fixed supply**

One of Bitcoin's most important properties is its fixed supply. There will only ever be 21 million bitcoins in existence. This scarcity is built into the code and cannot be changed. Compare this to traditional currencies, where governments can print more money at any time (which causes inflation).

**How new bitcoins are created**

New bitcoins are created through a process called "mining." Miners use powerful computers to solve complex mathematical puzzles. The first miner to solve the puzzle gets to add the next block to the blockchain and receives newly created bitcoin as a reward.

**Bitcoin as "digital gold"**

Many people see Bitcoin as a store of value — similar to gold. It's scarce, durable, and not controlled by any government. Some investors hold Bitcoin as a hedge against inflation or currency devaluation.

**Volatility**

Bitcoin's price can change dramatically — rising or falling 20–50% in weeks. This makes it a high-risk, high-reward asset. Never invest more than you can afford to lose.''',
        keyTakeaways: [
          'Bitcoin was created in 2009 by the anonymous Satoshi Nakamoto.',
          'It solves the double-spend problem without banks.',
          'Only 21 million bitcoins will ever exist — making it scarce.',
          'New bitcoins are created through mining.',
          'Many view Bitcoin as "digital gold" — a store of value.',
        ],
      ),
      Lesson(
        id: 'btc_2',
        title: 'How Bitcoin Transactions Work',
        readTime: '4 min read',
        difficulty: 'Beginner',
        body: '''When you send Bitcoin to someone, a surprisingly complex process happens behind the scenes — all within minutes.

**Step 1: Creating the transaction**

You enter the recipient's wallet address and the amount. Your wallet software creates a transaction message and signs it with your private key. This signature proves you authorized the transaction without revealing your private key.

**Step 2: Broadcasting**

The signed transaction is broadcast to the Bitcoin network — thousands of computers (nodes) around the world. Each node verifies the transaction: Does the sender have enough funds? Is the signature valid?

**Step 3: The mempool**

Valid transactions wait in a holding area called the "mempool" (memory pool). Miners pick transactions from the mempool to include in the next block.

**Step 4: Mining and confirmation**

Miners compete to solve a mathematical puzzle. The winner adds a new block containing your transaction to the blockchain. This is your first "confirmation." Each additional block added after that is another confirmation.

**Why confirmations matter**

One confirmation means your transaction is in the blockchain. Six confirmations (about 1 hour) is considered very secure — it would take an enormous amount of computing power to reverse a transaction with that many confirmations.

**Transaction fees**

You pay a small fee to miners as an incentive to include your transaction. Higher fees = faster processing. During busy periods, fees can rise significantly.

**UTXO model**

Bitcoin uses an "Unspent Transaction Output" system. Your balance isn't stored as a single number — it's made up of the change from previous transactions you've received. When you spend, your wallet automatically combines the right UTXOs.''',
        keyTakeaways: [
          'Transactions are signed with your private key — proving ownership without revealing it.',
          'Nodes verify transactions; miners add them to blocks.',
          'Each block added after yours is one more "confirmation."',
          'Six confirmations (~1 hour) is considered highly secure.',
          'Transaction fees incentivize miners and vary with network demand.',
        ],
      ),
      Lesson(
        id: 'btc_3',
        title: 'Bitcoin Halving Explained',
        readTime: '3 min read',
        difficulty: 'Intermediate',
        body: '''Every 210,000 blocks (roughly every 4 years), an event called the "Bitcoin halving" occurs. During a halving, the reward that miners receive for adding a new block to the blockchain is cut in half.

**Why does it exist?**

Satoshi Nakamoto built the halving into Bitcoin's code to control the rate at which new bitcoins enter circulation. Think of it like a countdown clock that gradually reduces Bitcoin's supply growth until the last bitcoin is mined around the year 2140.

**The history of halvings**

- **2009**: Block reward = 50 BTC
- **2012 halving**: Reward → 25 BTC
- **2016 halving**: Reward → 12.5 BTC
- **2020 halving**: Reward → 6.25 BTC
- **2024 halving**: Reward → 3.125 BTC

**Why does the market care?**

Historically, Bitcoin halvings have been followed by significant price increases. The logic is simple supply and demand: if demand stays the same but new supply entering the market is cut in half, the price should rise.

However, correlation isn't causation. Many other factors affect Bitcoin's price, and past performance doesn't guarantee future results.

**What happens when all bitcoins are mined?**

Miners will still be incentivized through transaction fees paid by users. As block rewards decrease, fees are expected to become the primary compensation for miners.

**Effect on miners**

Halvings reduce miner revenue overnight. Less efficient miners may become unprofitable and shut down, temporarily reducing the network's computing power. The network automatically adjusts mining difficulty to compensate.''',
        keyTakeaways: [
          'Every ~4 years, the Bitcoin block reward is cut in half.',
          'This controls Bitcoin\'s supply and slows down new coin creation.',
          'Only 21 million bitcoins will ever exist.',
          'Halvings have historically preceded major price increases.',
          'After all bitcoins are mined, miners will earn transaction fees only.',
        ],
      ),
    ],
  ),
  LessonCategory(
    id: 'ethereum',
    title: 'Ethereum',
    emoji: 'Ξ',
    color: Color(0xFF6366F1),
    lessons: [
      Lesson(
        id: 'eth_1',
        title: 'What is Ethereum?',
        readTime: '4 min read',
        difficulty: 'Beginner',
        body: '''Ethereum is the second-largest cryptocurrency by market cap, but it's much more than just a currency. Ethereum is a programmable blockchain — a global computer that anyone can use to build applications.

**Created by Vitalik Buterin**

Ethereum was proposed in 2013 by a young programmer named Vitalik Buterin and launched in 2015. Buterin's key insight was that Bitcoin's blockchain was essentially a calculator — powerful for payments, but limited. Ethereum would be a full computer: you could program it to do almost anything.

**Ether (ETH)**

The native currency of Ethereum is called Ether (ETH). You need ETH to pay for any action on the Ethereum network — this payment is called "gas." ETH is also widely traded as an investment.

**A platform for applications**

Think of Ethereum like a smartphone operating system. Just as iPhone's iOS lets developers build apps, Ethereum lets developers build decentralized applications (dApps). These apps run on the blockchain — meaning they're transparent, unstoppable, and don't require a company to maintain them.

**The Merge — from Proof of Work to Proof of Stake**

In 2022, Ethereum switched from an energy-intensive mining system (Proof of Work, like Bitcoin) to a more efficient system called Proof of Stake. In Proof of Stake, validators stake (lock up) their ETH as collateral to earn the right to validate transactions. This reduced Ethereum's energy consumption by ~99.95%.

**What's built on Ethereum?**

Decentralized finance (DeFi) apps, NFT marketplaces, DAOs (decentralized organizations), stablecoins, games, and much more. Ethereum hosts thousands of applications and processes millions of transactions daily.''',
        keyTakeaways: [
          'Ethereum is a programmable blockchain — not just a currency.',
          'ETH is the native currency used to pay for network actions (gas).',
          'Developers build decentralized apps (dApps) on Ethereum.',
          'Ethereum switched to Proof of Stake in 2022, cutting energy use by ~99.95%.',
          'DeFi, NFTs, and thousands of apps are built on Ethereum.',
        ],
      ),
      Lesson(
        id: 'eth_2',
        title: 'Smart Contracts Explained',
        readTime: '3 min read',
        difficulty: 'Beginner',
        body: '''A smart contract is a program stored on the blockchain that automatically executes when predetermined conditions are met. Think of it as a vending machine: put in the right amount, select your item, and it automatically dispenses — no cashier needed.

**Self-executing agreements**

Traditional contracts require lawyers, courts, and trust between parties. Smart contracts replace this with code. Once deployed on the blockchain, they run exactly as programmed — no one can stop them, alter them, or lie about the outcome.

Example: Imagine a bet between two people. A smart contract holds both parties' funds and automatically pays the winner based on a verifiable outcome (like a sports score from a trusted data source called an "oracle"). Neither party needs to trust the other — they only need to trust the code.

**How they work**

1. Two or more parties agree on terms
2. Those terms are written in code and deployed to the blockchain
3. The contract sits there, waiting for the conditions to be met
4. When conditions are met, it executes automatically — transferring funds, issuing tokens, updating records

**Immutability**

Once a smart contract is deployed, it generally cannot be changed. This is a strength (no one can alter the rules) and a weakness (bugs are also permanent). Auditing smart contract code before using it is critical.

**Real-world uses**

- DeFi: Lending, borrowing, and trading without banks
- NFTs: Proving ownership of digital assets
- DAOs: Decentralized governance where token holders vote on decisions
- Insurance: Automatic payouts when verified events occur (e.g., flight delays)
- Supply chain: Automatically releasing payment when goods are delivered''',
        keyTakeaways: [
          'Smart contracts are self-executing programs stored on the blockchain.',
          'They run automatically when conditions are met — no middleman needed.',
          'Once deployed, they generally cannot be changed.',
          'They power DeFi, NFTs, DAOs, and many other applications.',
          'Code bugs are permanent — auditing contracts is important before using them.',
        ],
      ),
      Lesson(
        id: 'eth_3',
        title: 'What is Gas?',
        readTime: '3 min read',
        difficulty: 'Intermediate',
        body: '''Every action on the Ethereum network — sending ETH, interacting with a smart contract, minting an NFT — requires computational resources. "Gas" is the unit that measures how much work a transaction requires, and you pay for it in ETH.

**Why gas exists**

Gas prevents spam. Without fees, someone could flood the network with millions of pointless transactions at no cost. By requiring ETH for every action, the network ensures that only genuine transactions are submitted.

**How gas fees are calculated**

Gas fee = Gas units × Gas price

- **Gas units**: Determined by how complex your transaction is. A simple ETH transfer uses 21,000 units. A complex smart contract interaction might use 500,000+.
- **Gas price**: Measured in "gwei" (one billionth of an ETH). This is what you're willing to pay per unit. Higher price = miners/validators prioritize your transaction.

**EIP-1559 — the fee market reform**

In 2021, Ethereum introduced a new fee model. There's now a "base fee" set by the network (and burned/destroyed), plus an optional "priority fee" (tip) you pay to validators to speed up your transaction.

This burning of ETH creates deflationary pressure — more transactions = more ETH burned = less total ETH in circulation.

**When are gas fees high?**

When the network is busy (many people transacting at once), gas prices spike. During periods of high activity like NFT drops or DeFi booms, fees can reach \$50–\$200+ per transaction.

**Layer 2 solutions**

To combat high fees, "Layer 2" networks (like Arbitrum and Optimism) process transactions off the main Ethereum chain and settle them in batches. This can reduce fees to fractions of a cent while inheriting Ethereum's security.''',
        keyTakeaways: [
          'Gas measures the computational work a transaction requires.',
          'You pay gas fees in ETH — they go to validators as compensation.',
          'Gas fees prevent spam by making every action cost something.',
          'Since EIP-1559, a portion of fees is burned, making ETH slightly deflationary.',
          'Layer 2 networks dramatically reduce gas costs.',
        ],
      ),
    ],
  ),
  LessonCategory(
    id: 'trading',
    title: 'Trading',
    emoji: '📈',
    color: Color(0xFF10B981),
    lessons: [
      Lesson(
        id: 'trading_1',
        title: 'Market Cap Explained',
        readTime: '3 min read',
        difficulty: 'Beginner',
        body: '''Market capitalization — or "market cap" — is one of the most important metrics for evaluating a cryptocurrency. It tells you the total value of all coins currently in circulation.

**The formula**

Market Cap = Current Price × Circulating Supply

Example: If Bitcoin's price is \$60,000 and there are 19.5 million BTC in circulation:
Market Cap = \$60,000 × 19,500,000 = \$1.17 trillion

**Why market cap matters more than price**

A coin's price alone can be misleading. A coin priced at \$1 might have a larger market cap than one priced at \$1,000 — if the \$1 coin has billions in circulation. Market cap gives a better picture of a project's overall size and value.

**Market cap categories**

- **Large cap** (>\$10B): Bitcoin, Ethereum — more established, generally less volatile
- **Mid cap** (\$1B–\$10B): More growth potential, higher risk
- **Small cap** (<\$1B): High risk, high potential reward, easier to manipulate

**Total Market Cap**

The "total crypto market cap" is the sum of all cryptocurrency market caps. It's often used to gauge the overall health of the crypto market.

**Fully Diluted Valuation (FDV)**

FDV = Current Price × Maximum Total Supply (including coins not yet in circulation). If a coin has a huge number of future coins to be released, the FDV can be much larger than the current market cap — a potential red flag.

**Limitations**

Market cap doesn't tell you about liquidity, team quality, technology, or whether a project is actually used. Use it as one of many tools, not the only one.''',
        keyTakeaways: [
          'Market cap = price × circulating supply.',
          'Market cap is more useful than price alone for comparing projects.',
          'Large caps are more stable; small caps are higher risk/reward.',
          'FDV accounts for coins not yet in circulation — watch for inflation risk.',
          'Market cap is one metric — always evaluate other factors too.',
        ],
      ),
      Lesson(
        id: 'trading_2',
        title: 'Reading a Price Chart',
        readTime: '4 min read',
        difficulty: 'Intermediate',
        body: '''Price charts are the primary tool traders use to analyze cryptocurrency markets. Learning to read them is an essential skill.

**Candlestick charts**

The most common chart type is the candlestick chart. Each "candle" represents price action over a specific time period (1 minute, 1 hour, 1 day, etc.).

Each candle has four data points:
- **Open**: Price at the start of the period
- **Close**: Price at the end of the period
- **High**: Highest price during the period
- **Low**: Lowest price during the period

If the close is higher than the open, the candle is green (bullish). If the close is lower, it's red (bearish). The thin lines above and below the candle body are called "wicks" and show the high/low range.

**Support and resistance**

- **Support**: A price level where buying pressure tends to emerge, preventing further drops. Think of it as a "floor."
- **Resistance**: A price level where selling pressure tends to emerge, preventing further gains. Think of it as a "ceiling."

When price breaks through resistance, that level often becomes new support — and vice versa.

**Volume**

Volume bars at the bottom of a chart show how much of a coin was traded in each period. High volume during a price move confirms the move is significant. Low volume moves are often less reliable.

**Trend lines**

Drawing a line connecting higher lows shows an uptrend. Connecting lower highs shows a downtrend. When price breaks a trend line with high volume, it often signals a trend change.

**A word of caution**

Technical analysis is not a crystal ball. Charts show you what has happened, not what will happen. They work best in combination with understanding the fundamental value of what you're trading.''',
        keyTakeaways: [
          'Candlestick charts show open, close, high, and low for each time period.',
          'Green candles = price went up; red candles = price went down.',
          'Support is a "floor"; resistance is a "ceiling" for price.',
          'High volume confirms the significance of a price move.',
          'Technical analysis shows patterns, not certainties — always manage risk.',
        ],
      ),
      Lesson(
        id: 'trading_3',
        title: 'Bull vs Bear Markets',
        readTime: '3 min read',
        difficulty: 'Beginner',
        body: '''If you follow crypto news, you'll constantly hear about "bull markets" and "bear markets." These terms describe the overall direction and sentiment of the market.

**Bull market**

A bull market is a sustained period of rising prices and widespread optimism. The name comes from how a bull attacks — thrusting its horns upward. During a bull market:
- Prices rise consistently over weeks or months
- New investors enter the market (FOMO — fear of missing out)
- Media coverage is overwhelmingly positive
- Even low-quality projects see their prices rise

The crypto bull markets of 2017 and 2020–2021 saw Bitcoin rise from a few thousand dollars to nearly \$20,000 and then to \$69,000 respectively.

**Bear market**

A bear market is a sustained period of falling prices and pessimism. The name comes from how a bear attacks — swiping its paws downward. During a bear market:
- Prices fall 20%+ from recent highs (crypto often falls 70–90%+)
- Investor sentiment is fearful and negative
- Many projects fail or are abandoned
- Media declares crypto is "dead" — often for the tenth time

**The cycle**

Crypto markets have historically moved in cycles: accumulation → bull run → distribution → bear market → accumulation again. Each cycle has tended to reach a higher peak than the last, though this is not guaranteed.

**Strategies for each**

- **Bull**: Take profits on the way up, don't get greedy at the top
- **Bear**: DCA (dollar-cost average) if you believe in the long-term, cut losses on failed projects, focus on projects with strong fundamentals

**"Be fearful when others are greedy, and greedy when others are fearful."** — Warren Buffett's advice applies well to crypto cycles.''',
        keyTakeaways: [
          'Bull market = rising prices and optimism; bear market = falling prices and fear.',
          'Crypto bear markets often see 70–90%+ price drops from all-time highs.',
          'Markets move in cycles: accumulation → bull → distribution → bear.',
          'In a bull market, take profits; in a bear market, focus on strong fundamentals.',
          'Emotional decision-making (FOMO and panic) is the biggest trap for traders.',
        ],
      ),
    ],
  ),
  LessonCategory(
    id: 'security',
    title: 'Security',
    emoji: '🔒',
    color: Color(0xFFEF4444),
    lessons: [
      Lesson(
        id: 'sec_1',
        title: 'How to Stay Safe in Crypto',
        readTime: '4 min read',
        difficulty: 'Beginner',
        body: '''Crypto gives you full control of your money — but that means full responsibility too. Unlike a bank, there's no fraud department to call, no chargebacks, and no "I forgot my password" recovery. Here's how to protect yourself.

**Use strong, unique passwords**

Every crypto account should have a different, complex password. Use a password manager (like Bitwarden or 1Password) rather than reusing passwords or writing them on sticky notes.

**Enable two-factor authentication (2FA)**

Always enable 2FA on exchanges and wallets. Use an authenticator app (like Google Authenticator or Authy) — not SMS-based 2FA, which can be compromised via "SIM swapping" attacks where scammers trick your carrier into transferring your number.

**Never share your private key or seed phrase**

No legitimate service will ever ask for your private key or seed phrase. Anyone who asks is trying to steal your funds. Period. Write your seed phrase on paper, store it somewhere safe (consider a fireproof safe), and never photograph it or store it digitally.

**Use hardware wallets for large amounts**

If you hold significant crypto, a hardware wallet (like a Ledger or Trezor) keeps your private keys offline — out of reach of hackers. Only connect it when you need to transact.

**Beware of phishing**

Scammers create fake websites that look identical to real exchanges or wallets. Always check the URL carefully. Bookmark the sites you use. Never click links in emails or DMs claiming to be from a crypto platform.

**Verify before you send**

Cryptocurrency transactions are irreversible. Always double-check the recipient's wallet address before confirming. Some malware ("clipboard hijacking") replaces copied wallet addresses with the attacker's address.

**Use reputable exchanges**

Stick to well-known, regulated exchanges. Research any platform before depositing funds. "Not your keys, not your coins" — if an exchange holds your crypto, you're trusting them completely.''',
        keyTakeaways: [
          'Use unique passwords and an authenticator app for 2FA — not SMS.',
          'Never share your private key or seed phrase with anyone.',
          'Use a hardware wallet for large amounts — keeps keys offline.',
          'Always verify wallet addresses before sending — transactions are irreversible.',
          'Beware of phishing sites — bookmark sites you use regularly.',
        ],
      ),
      Lesson(
        id: 'sec_2',
        title: 'What is a Private Key?',
        readTime: '3 min read',
        difficulty: 'Beginner',
        body: '''Your private key is the most important piece of information in crypto. Understanding exactly what it is — and why protecting it matters — is essential.

**What is it?**

A private key is a long, randomly generated number, typically displayed as a string of 64 hexadecimal characters. For example:
3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f2b

From this one number, your wallet derives your public key (your address). The math only works one way — you cannot reverse-engineer the private key from the public key.

**What can someone do with your private key?**

Everything. They can transfer all your funds to themselves instantly, and you cannot stop it. There's no freeze, no reversal, no recourse. This is why protecting your private key is the single most important thing in crypto security.

**How keys are generated**

Private keys are generated using cryptographically secure random number generators. The randomness is critical — a predictable key is a vulnerable key. This is why you should never create a private key yourself (rolling dice, etc.) and always use reputable wallet software.

**Seed phrase vs private key**

Most modern wallets use a "seed phrase" (also called a mnemonic) — 12 or 24 common English words. This seed mathematically generates your private key(s). The seed phrase is easier to write down and remember than a raw key. But they're equally powerful — anyone with your seed phrase controls your funds.

**Storage best practices**

- Write it on paper (or engrave on metal for fire/water resistance)
- Store in multiple secure physical locations
- Never store digitally (phone, computer, cloud, email)
- Never photograph it
- Consider splitting it: give half to two separate secure locations (though this reduces security if one is found)''',
        keyTakeaways: [
          'A private key is a 64-character number that proves ownership of your funds.',
          'Anyone with your private key can take all your funds — immediately and irreversibly.',
          'Private keys generate your public address, but not the other way around.',
          'Your seed phrase generates your private key — protect it equally.',
          'Store private keys/seed phrases offline, physically, in multiple secure locations.',
        ],
      ),
      Lesson(
        id: 'sec_3',
        title: 'Avoiding Crypto Scams',
        readTime: '4 min read',
        difficulty: 'Beginner',
        body: '''Crypto scams cost people billions of dollars every year. Scammers specifically target crypto because transactions are irreversible and pseudonymous. Knowing the most common scam types is your first defense.

**"Too good to be true" investments**

If someone promises guaranteed returns — "Send 1 BTC, get 2 BTC back!" — it's a scam. No legitimate investment guarantees returns. These are Ponzi schemes that pay early investors with later investors' money until they collapse.

**Fake giveaways**

Scammers impersonate Elon Musk, MrBeast, or popular crypto projects on social media, claiming to "double" any crypto you send. Legitimate giveaways never require you to send anything first.

**Pig butchering scams**

Someone befriends you online (often romantically) over weeks or months. Once they've built trust, they introduce you to a "great investment opportunity" — a fake crypto platform. You deposit funds and see fake profits. When you try to withdraw, they make excuses or disappear. Hundreds of millions are lost this way annually.

**Fake apps and websites**

Scammers create convincing fake versions of popular exchanges and wallets. Always download apps from official sources (App Store/Google Play), verify URLs carefully, and use bookmarks.

**Rug pulls**

A new crypto project launches with big promises. The team hypes it, attracts investors, then suddenly withdraws all the liquidity and disappears with the funds. Research teams thoroughly. Anonymous teams with no track record are a red flag.

**Social engineering**

Scammers pose as customer support (on Twitter, Telegram, Discord) and ask for your seed phrase or private key to "verify" your account or "fix" a problem. Real support never asks for these.

**Recovery scams**

If you've already been scammed, be extra careful — scammers also target victims with promises to recover lost funds (for an upfront fee). This is another scam. Stolen crypto is almost never recoverable.

**The golden rules**

1. Never send crypto to receive crypto
2. Never share your seed phrase or private key
3. Verify everything through official channels
4. If it seems too good to be true, it is''',
        keyTakeaways: [
          'Guaranteed returns are always a scam — no exceptions.',
          'Giveaways that require you to send first are always fake.',
          'Pig butchering scams build trust over weeks before stealing funds.',
          'Legitimate support never asks for your seed phrase or private key.',
          'If something seems too good to be true, it is — walk away.',
        ],
      ),
    ],
  ),
  LessonCategory(
    id: 'defi',
    title: 'DeFi',
    emoji: '🏦',
    color: Color(0xFF8B5CF6),
    lessons: [
      Lesson(
        id: 'defi_1',
        title: 'What is DeFi?',
        readTime: '4 min read',
        difficulty: 'Intermediate',
        body: '''DeFi stands for "Decentralized Finance." It's a broad term for financial services — lending, borrowing, trading, earning interest — that operate on public blockchains instead of through traditional banks and institutions.

**The problem DeFi solves**

Traditional finance requires gatekeepers: banks decide who gets loans, brokers facilitate trades, insurance companies approve claims. These intermediaries add costs, delays, and exclusion — over 1.4 billion adults worldwide have no access to basic banking.

DeFi replaces these intermediaries with smart contracts — code that executes automatically, transparently, and without discrimination. Anyone with a crypto wallet and internet access can use DeFi.

**Key DeFi services**

- **Decentralized Exchanges (DEXs)**: Trade tokens directly from your wallet without a central exchange. Uniswap, Curve, and dYdX are examples. Prices are set by automated market makers (AMMs) — algorithms rather than order books.
- **Lending & Borrowing**: Platforms like Aave and Compound let you lend crypto to earn interest, or borrow against your crypto as collateral — no credit check required.
- **Yield Farming**: Providing liquidity to a protocol in exchange for token rewards. High potential returns, but complex and risky.
- **Stablecoins**: DAI is a decentralized stablecoin pegged to the US dollar, created by smart contracts — not backed by a company holding dollars.

**The risks**

DeFi is powerful but risky:
- **Smart contract bugs**: If the code has a vulnerability, hackers can drain funds. Hundreds of millions have been lost to DeFi hacks.
- **Impermanent loss**: Providing liquidity can result in losses compared to simply holding the tokens.
- **Complexity**: DeFi is not user-friendly. Mistakes are irreversible.
- **Regulatory uncertainty**: Governments are still figuring out how to regulate DeFi.

**"Not your keys, not your coins"**

In DeFi, you control your keys. But this means you're also fully responsible for your security.''',
        keyTakeaways: [
          'DeFi provides financial services on blockchains — no banks or intermediaries.',
          'Anyone with a wallet can access DeFi, regardless of location or credit history.',
          'Key services: DEXs (trading), lending, yield farming, stablecoins.',
          'Smart contract vulnerabilities have led to massive hacks — risk is real.',
          'DeFi gives full control — and full responsibility.',
        ],
      ),
      Lesson(
        id: 'defi_2',
        title: 'Staking Explained',
        readTime: '3 min read',
        difficulty: 'Intermediate',
        body: '''Staking is one of the most accessible ways to earn passive income in crypto. If you hold certain cryptocurrencies, you can "stake" them to help secure the network and earn rewards in return.

**Proof of Stake — the foundation**

Staking only exists on Proof of Stake (PoS) blockchains. In PoS, validators are chosen to create new blocks and verify transactions based on how much cryptocurrency they've "staked" (locked up as collateral). If a validator tries to cheat, they lose their staked funds — this is called "slashing."

In exchange for helping secure the network, validators earn newly created coins and transaction fees. This is the reward you receive when you stake.

**How to stake**

1. **Direct staking**: Run your own validator node. Requires significant technical knowledge and usually a minimum stake (32 ETH for Ethereum, for example).
2. **Delegated staking**: Delegate your coins to an existing validator through a crypto exchange or platform. Simpler but you share the rewards (and they take a cut).
3. **Liquid staking**: Protocols like Lido let you stake ETH and receive "stETH" in return — a token that represents your staked ETH and accrues rewards, while remaining usable in DeFi.

**Staking rewards**

Returns vary widely — from 3–4% APY for Ethereum to 10–20%+ for some smaller chains. But higher yields often come with higher risk.

**Lock-up periods**

Some staking requires locking your coins for a fixed period. If the price drops during the lock-up, you cannot sell — factor this into your decision.

**Risks**

- Slashing (if the validator misbehaves)
- Smart contract bugs in staking platforms
- Lock-up risk if price falls
- Regulatory risk (some jurisdictions view staking rewards as taxable income)''',
        keyTakeaways: [
          'Staking helps secure Proof of Stake blockchains and earns you rewards.',
          'You can stake directly, through exchanges, or via liquid staking protocols.',
          'Returns vary — higher yield often means higher risk.',
          'Some staking requires locking coins for a period — you can\'t sell during this time.',
          'Validators can be "slashed" (lose funds) for misbehaving.',
        ],
      ),
      Lesson(
        id: 'defi_3',
        title: 'Liquidity Pools',
        readTime: '4 min read',
        difficulty: 'Intermediate',
        body: '''Liquidity pools are one of the foundational innovations of DeFi. They're what allows decentralized exchanges to work without a central order book — and they let regular users earn fees by providing that liquidity.

**The problem with traditional order books**

On traditional exchanges (like stock markets), buyers and sellers are matched in an order book. But for this to work, there need to be enough buyers and sellers at any given moment. For low-volume crypto tokens, this is often a problem — you might not find anyone to trade with.

**How liquidity pools work**

A liquidity pool is a smart contract holding two tokens (e.g., ETH and USDC). Users called "liquidity providers" (LPs) deposit equal values of both tokens into the pool.

When a trader wants to swap ETH for USDC, they swap with the pool — not another person. An algorithm called an Automated Market Maker (AMM) determines the price based on the ratio of tokens in the pool. The most common AMM formula is x × y = k (constant product formula, used by Uniswap).

As trades happen, the ratio shifts, automatically adjusting the price.

**Earning fees as a liquidity provider**

Every swap charges a small fee (typically 0.3%). These fees are distributed proportionally to all LPs based on their share of the pool. If a pool does high volume, LPs can earn significant fees.

**Impermanent loss**

This is the main risk for LPs. If the prices of the two tokens diverge significantly from when you deposited, you end up with less value than if you'd simply held the tokens. It's "impermanent" because if prices return to the original ratio, the loss disappears — but if you withdraw at the wrong time, it becomes permanent.

Example: If you deposit 50% ETH and 50% USDC, and ETH price doubles, the AMM rebalances — you now hold less ETH and more USDC than you started with. You've "sold" ETH on the way up automatically.

**When is providing liquidity worth it?**

Providing liquidity makes the most sense when:
- The two tokens are strongly correlated (e.g., stablecoin pairs have minimal impermanent loss)
- The pool has high trading volume (more fees to offset any impermanent loss)
- You receive additional token rewards (liquidity mining)''',
        keyTakeaways: [
          'Liquidity pools let DEXs function without order books.',
          'Liquidity providers deposit two tokens and earn a share of trading fees.',
          'AMMs use formulas (like x×y=k) to automatically price trades.',
          'Impermanent loss occurs when token prices diverge — a key risk for LPs.',
          'Stablecoin pools minimize impermanent loss; high-volume pools maximize fee income.',
        ],
      ),
    ],
  ),
];
