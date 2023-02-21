import React, { useState } from "react";
import NavBar from "../../components/NavBar/NavBar";
import "./Home.css";
import { Chart as 
  ChartJS, 
  ArcElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip, 
  Legend } from 'chart.js';
import { Doughnut } from 'react-chartjs-2';
import Utils from "../../library/Utils";
import { 
  Currency, 
  Overview, 
  SpendingCategories, 
  Subscriptions, 
  SubscriptionsAll, 
  TopBeneficiaries, 
  TopDebits } from "../../library/Data";
import "../../components/Card/Card.css";
import List from "../../components/List/List";
import { Link } from "react-router-dom";
import { HomeCategoriesView, SpendingCategoriesSelector } from "../../library/Variables";
import Dropdown from "../../components/Dropdown/Dropdown";
import SubscriptionsContent from "./Sections/SubscriptionsContent";
import SpendingCategoriesContent from "./Sections/SpendingCategoriesContent";

function Home() {
  ChartJS.register(
    CategoryScale,
    LinearScale,
    ArcElement,
    Title,
    Tooltip,
    Legend,
  );

  let content = null;
  let pieData = [];
  let pieLabels = [];

  const [category, setCategory] = useState(SpendingCategoriesSelector.SEVEN);
  const [view, setView] = useState(HomeCategoriesView.INITIAL);
  const pieChartColors = ["#0CBC8B", "#FF725E", "#C4A2FC"];

  let dataMap = [
    {
      label: 'Airtime And Data',
      total: Utils.checkNull(SpendingCategories[category].airtimeAndData),
      transactions: 7
    },
    {
      label: 'Food and drinks',
      total: Utils.checkNull(SpendingCategories[category].foodAndDrinks),
      transactions: 6
    },
    {
      label: 'Electricity',
      total: Utils.checkNull(SpendingCategories[category].electricity),
      transactions: 5
    },
    {
      label: 'Bars, Lounge and Clubs',
      total: Utils.checkNull(SpendingCategories[category].barsLoungeAndClubs),
      transactions: 3
    },
    {
      label: 'Waste and Water',
      total: Utils.checkNull(SpendingCategories[category].wasteAndWater),
      transactions: 8
    },
    {
      label: 'ATM withdrawals',
      total: Utils.checkNull(SpendingCategories[category].atmWithdrawals),
      transactions: 11
    },
    {
      label: 'Grocery and Malls',
      total: Utils.checkNull(SpendingCategories[category].groceryAndMalls),
      transactions: 2
    },
    {
      label: 'Charges and Stamp duty',
      total: Utils.checkNull(SpendingCategories[category].chargesAndStampDuty),
      transactions: 5
    },
    {
      label: 'Insurance',
      total: Utils.checkNull(SpendingCategories[category].insurance),
      transactions: 4
    },
    {
      label: 'Family',
      total: Utils.checkNull(SpendingCategories[category].family),
      transactions: 9
    },
    {
      label: 'Transportation',
      total: Utils.checkNull(SpendingCategories[category].transportation),
      transactions: 1
    },
    {
      label: 'Savings and Investment',
      total: Utils.checkNull(SpendingCategories[category].savingsAndInvestment),
      transactions: 2
    },
    {
      label: 'Online/Web Purchases',
      total: Utils.checkNull(SpendingCategories[category].onlineWebPurchases),
      transactions: 7
    },
    {
      label: 'Health & Fitness',
      total: Utils.checkNull(SpendingCategories[category].healthFitness),
      transactions: 3
    },
    {
      label: 'POS spend',
      total: Utils.checkNull(SpendingCategories[category].posSpend),
      transactions: 5
    },
    {
      label: 'Uncategorized/Miscellaneous',
      total: Utils.checkNull(SpendingCategories[category].uncategorizedMiscellaneous),
      transactions: 1
    },
    {
      label: 'Self Transfer',
      total: Utils.checkNull(SpendingCategories[category].selfTransfer),
      transactions: 0
    }
  ]

  const sumOfTotals = (array) => {
    let total = array.reduce((accumulator, object) => {
      return accumulator + object.total;
    }, 0)

    return total;
  }

  const navbarContent = <List listClass="list-row list-row-even list-flex" listItemClass="list-item-col" 
    headerClass={"text-medium list-header-small list-header-light list-header-row"}
    listDetailClass="text-dark list-detail-big list-detail-bold" listContent={[
      {
        header: "Total Inflow",
        detail: Utils.formatCurrency(Currency.format, Currency.symbol, Overview.totalInflow),
        legendColor: "#0CBC8B"
      },
      {
        header: "Total Outflow",
        detail: Utils.formatCurrency(Currency.format, Currency.symbol, Overview.totalOutflow),
        legendColor: "#FF725E"
      },
      {
        header: "Average Monthly Income",
        detail: Utils.formatCurrency(Currency.format, Currency.symbol, Overview.averageMonthlyIncome),
        legendColor: "#C4A2FC"
      },
      {
        header: "Average Monthly Expenses",
        detail: Utils.formatCurrency(Currency.format, Currency.symbol, Overview.averageMonthlyExpenses),
        legendColor: "#4C3EDB"
      },
      {
        header: "Average Predicted Salary",
        detail: Utils.formatCurrency(Currency.format, Currency.symbol, Overview.averagePredictedSalary),
        legendColor: "#FFBC73"
      }
    ]} />

  const backButton = <button className="button-back" onClick={() => setView(HomeCategoriesView.INITIAL)}>
    <img src="/assets/icons/arrow-left.svg" alt="" />
    Back
  </button>

  const dropdownOptions = [
    {
      type: "DATE_RANGE",
      label: "Custom Range",
      value: SpendingCategoriesSelector.CUSTOM,
      dates: [
        {
          label: "Start date",
          param: "startDate"
        },
        {
          label: "End date",
          param: "endDate"
        }
      ]
    }
  ]

  dataMap.sort((a, b) => b.total - a.total);

  dataMap = dataMap.slice(0, 3);

  const pieChartOptions = {
    cutout: 80,
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      tooltip: {
        enabled: true
      },
      legend: {
        display: false
      },
    }
  }

  dataMap.forEach((element, i) => {
    pieData.push(element.total);
    pieLabels.push(element.label);
  })

  const handleDropdownDateCallback = (date, value, param) => {
    setCategory(value);
  }

  const isActiveCategory = (target) => {
    if(target === category) {
      return "active-category"
    }
  }

  if(view === HomeCategoriesView.INITIAL) {
    content = <>
      <div className="card">
        <div className="header-row">
          <h2 className="text-dark">Spending Categories</h2>
          <div className="spending-categories-container">
            <button className={isActiveCategory(SpendingCategoriesSelector.SEVEN)} 
              onClick={() => setCategory(SpendingCategoriesSelector.SEVEN)}>Last 7 Days</button>
            <button className={isActiveCategory(SpendingCategoriesSelector.THIRTY)} 
              onClick={() => setCategory(SpendingCategoriesSelector.THIRTY)}>Last 30 Days</button>
            <button className={isActiveCategory(SpendingCategoriesSelector.YEAR)} 
              onClick={() => setCategory(SpendingCategoriesSelector.YEAR)}>This Year</button>
            <Dropdown options={dropdownOptions} selectClass={isActiveCategory(SpendingCategoriesSelector.CUSTOM)}
              parentDateCallBack={(date, value, param) => handleDropdownDateCallback(date, value, param)} />
          </div>
        </div>
        <div className="doughnut-chart-container">
          {pieData.map((data, i) => {
            return <div className="doughnut-chart" key={i}>
              <p className="doughnut-chart-center-label text-medium">{Utils.formatDecimalPercentage(data/(sumOfTotals(dataMap)))}</p>
              <Doughnut data={{
                labels: [pieLabels[i], "total"],
                datasets: [
                  {
                    data: [data, sumOfTotals(dataMap)],
                    backgroundColor: [pieChartColors[i], "#D8E0E7"]
                  }
                ]
              }} options={pieChartOptions} />
              <p className="doughnut-chart-name-label">{pieLabels[i]}</p>
            </div>
          })
          }
        </div>
        <div className="button-row-end">
          <button className="button-link-lighter button-link-bold button-text-large" 
            onClick={() => setView(HomeCategoriesView.CATEGORIES)}>See all</button>
        </div>
      </div>
      <SubscriptionsContent data={Subscriptions} title="Subscriptions" parentCallback={() => setView(HomeCategoriesView.SUBSCRIPTIONS)} />
      <div className="top-spending-container">
        <div className="card top-spending">
          <div className="header-row">
            <h2 className="text-dark">Top Debits</h2>
            <Link to={""} style={{ pointerEvents: "none" }}>See all</Link>
          </div>
          <List listClass="list-col" listItemClass="list-row-two-colored list-top-bottom-border" listContent={TopDebits} />
        </div>
        <div className="card top-spending">
          <div className="header-row">
            <h2 className="text-dark">Top Credits</h2>
            <Link to={""} style={{ pointerEvents: "none" }}>See all</Link>
          </div>
          <List listClass="list-col" listItemClass="list-row-two-colored list-top-bottom-border" listContent={TopBeneficiaries} />
        </div>
      </div>
    </>
  } else if(view === HomeCategoriesView.SUBSCRIPTIONS) {
    content = <>
      {backButton}
      <SubscriptionsContent data={SubscriptionsAll} title="All Subscriptions" class="all-subscriptions" />
    </>
  } else if(view === HomeCategoriesView.CATEGORIES) {
    content = <>
      {backButton}
      <SpendingCategoriesContent dropdownOptions={dropdownOptions} />
    </>
  }

  return (
    <>
      <NavBar header="Hello, Sam" content={navbarContent} contentClass="navbar-home-stats" />
      <div className="home-body">
        {content}
      </div>
    </>
  )
}

export default Home;