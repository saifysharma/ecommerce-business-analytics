# E-Commerce Business Analytics

**SQL + Power BI analysis of an e-commerce business to evaluate sales performance, product performance, customer behavior, marketing effectiveness, and the customer purchase funnel.**

## Business Problem

The e-commerce company collects large volumes of transactional and customer behavior data. However, management lacks clear visibility into overall business performance, customer purchasing behavior, product performance, marketing effectiveness, and customer drop-off throughout the purchase funnel.

Without these insights, it becomes difficult to make informed, data-driven decisions to improve revenue, customer experience, and business growth.

## Business Objective

Analyze **sales performance, customer behavior, product performance, marketing effectiveness, and the customer conversion funnel** to identify trends, opportunities, and actionable business recommendations that support data-driven decision-making.

## Dataset

**E-commerce Transactions + Clickstream Dataset — Kaggle**

The dataset contains seven related tables:

- Customers
- Products
- Orders
- Order Items
- Sessions
- Events
- Reviews

The dataset was used as provided for the analysis. The project focuses on **SQL-based business analysis and Power BI visualization**.

## Tools

- **MySQL / SQL** — Business analysis and calculations
- **Power BI** — Interactive dashboard and visualization
- **Kaggle** — Dataset source

## Business Analysis

### Sales Performance

Analyzed revenue, orders, average order value, units sold, discounts, profit, profit margin, monthly trends, category performance, geographic performance, payment methods, devices, and traffic sources.

### Product Performance

Evaluated products and categories using revenue, units sold, profit, profit margin, ratings, reviews, and the relationship between product ratings and sales.

### Customer Behavior

Analyzed customer spending, purchasing frequency, repeat purchasing, customer acquisition, top customers, and customer lifetime value segments.

### Marketing Effectiveness

Compared sessions, purchases, and conversion rates across traffic sources, devices, and countries to evaluate marketing performance.

### Purchase Funnel

Analyzed the customer journey:

**Page View → Add to Cart → Checkout → Purchase**

to measure stage conversion, identify major drop-offs, and investigate high-view but low-purchase products.

## Key Insights

### Sales

- **Revenue:** Revenue peaked at **$405K in October** before falling to **$313K in November**.
- **Profit:** Profit peaked at approximately **$154K in October** before falling to approximately **$119K in November**.
- **Categories:** **Home & Kitchen, Sports, and Fashion** lead revenue.
- **Markets:** The **US** leads revenue at approximately **$820K**, followed by **GB and India**.
- **Payments:** **Card payments** contribute approximately **70% of revenue**.
- **Discounts:** Sales with **0% discount** generate approximately **$2.1M**, substantially higher than discounted sales.

### Customers

- Approximately **20K customers generated 33.6K orders**, indicating meaningful repeat purchasing activity.

### Products

- **Top Seller:** **Lipstick Light Blue 766** leads with **179 units sold**.
- **Profitability:** Higher sales volume does not always translate into the highest profit.
- **Ratings:** Best-selling products generally maintain ratings between **3.6 and 4.3**.
- **Rating vs Sales:** Product rating alone does not appear to determine sales volume.

### Marketing

- **Device:** **Mobile** drives approximately **66K sessions**, significantly ahead of desktop.
- **Traffic:** **Organic** is the largest traffic source with approximately **40.8K sessions**.
- **Conversion:** **Paid and Referral** lead conversion performance at approximately **28.49%**.
- **Opportunity:** Organic generates high traffic but has the **lowest conversion rate**, indicating an opportunity to improve traffic quality and conversion.

### Funnel

- **Page Views:** **73.46%** of users drop off before Add to Cart.
- **Cart:** **68.62%** drop off from **Add to Cart → Checkout**.
- **Checkout:** **25.23%** drop off before Purchase.
- **Overall Conversion:** Overall **Page View → Purchase conversion is 6.2%**.

## Business Recommendations

1. **Investigate the October → November revenue decline** by breaking the change down by product, category, market, device, and traffic source.

2. **Improve the Add to Cart → Checkout stage**, where the largest funnel drop-off occurs, by investigating checkout usability, unexpected costs, shipping information, payment options, and technical friction.

3. **Optimize organic traffic conversion** by reviewing landing pages, search intent, product relevance, and traffic quality.

4. **Prioritize profitable products and categories**, rather than relying on units sold alone, because higher sales volume does not always result in the highest profit.

5. **Strengthen retention of repeat and high-value customers** through personalized offers, loyalty incentives, and cross-selling.

6. **Review high-view, low-purchase products** for potential issues with pricing, product descriptions, images, ratings, availability, and customer trust.

7. **Evaluate discount strategy carefully.** Since 0%-discount sales generate approximately **$2.1M**, targeted discounts should be tested based on incremental revenue rather than assuming larger discounts always improve performance.

8. **Monitor payment performance**, particularly card payments which contribute approximately **70% of revenue**, while maintaining suitable alternative payment options.

## Power BI Dashboard

The Power BI report contains six pages:

**Overview | Sales | Products | Customers | Marketing | Funnel**

### Overview

![Overview Dashboard](Dashboard/overview.png)

### Sales Analysis

![Sales Dashboard](Dashboard/sales.png)

### Product Analysis

![Product Dashboard](Dashboard/products.png)

### Customer Analysis

![Customer Dashboard](Dashboard/customers.png)

### Marketing Analysis

![Marketing Dashboard](Dashboard/marketing.png)

### Funnel Analysis

![Funnel Dashboard](Dashboard/funnel.png)

## Project Deliverables

- 5 SQL analysis files
- Interactive Power BI dashboard
- 6 dashboard page previews
- Business insights
- Actionable business recommendations

## Outcome

The project demonstrates how **SQL can be used to investigate business performance and how analytical findings can be translated into actionable decisions through Power BI**.

