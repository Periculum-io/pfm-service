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
  let listData = [];

  const [category, setCategory] = useState(SpendingCategoriesSelector.SEVEN);
  const [view, setView] = useState(HomeCategoriesView.INITIAL);
  const [activeChartArea, setActiveChartArea] = useState({ index: null, label: "100%" });
  const pieChartColors = ["#0CBC8B", "#FF725E", "#C4A2FC", "#4C3EDB", "#FFBC73"];

  let dataMap = [
    {
      label: 'Airtime And Data',
      total: Utils.checkNull(SpendingCategories[category].airtimeAndData)
    },
    {
      label: 'Food and drinks',
      total: Utils.checkNull(SpendingCategories[category].foodAndDrinks)
    },
    {
      label: 'Electricity',
      total: Utils.checkNull(SpendingCategories[category].electricity)
    },
    {
      label: 'Bars, Lounge and Clubs',
      total: Utils.checkNull(SpendingCategories[category].barsLoungeAndClubs)
    },
    {
      label: 'Waste and Water',
      total: Utils.checkNull(SpendingCategories[category].wasteAndWater)
    },
    {
      label: 'ATM withdrawals',
      total: Utils.checkNull(SpendingCategories[category].atmWithdrawals)
    },
    {
      label: 'Grocery and Malls',
      total: Utils.checkNull(SpendingCategories[category].groceryAndMalls)
    },
    {
      label: 'Charges and Stamp duty',
      total: Utils.checkNull(SpendingCategories[category].chargesAndStampDuty)
    },
    {
      label: 'Insurance',
      total: Utils.checkNull(SpendingCategories[category].insurance)
    },
    {
      label: 'Family',
      total: Utils.checkNull(SpendingCategories[category].family)
    },
    {
      label: 'Transportation',
      total: Utils.checkNull(SpendingCategories[category].transportation)
    },
    {
      label: 'Savings and Investment',
      total: Utils.checkNull(SpendingCategories[category].savingsAndInvestment)
    },
    {
      label: 'Online/Web Purchases',
      total: Utils.checkNull(SpendingCategories[category].onlineWebPurchases)
    },
    {
      label: 'Health & Fitness',
      total: Utils.checkNull(SpendingCategories[category].healthFitness)
    },
    {
      label: 'POS spend',
      total: Utils.checkNull(SpendingCategories[category].posSpend)
    },
    {
      label: 'Uncategorized/Miscellaneous',
      total: Utils.checkNull(SpendingCategories[category].uncategorizedMiscellaneous)
    },
    {
      label: 'Self Transfer',
      total: Utils.checkNull(SpendingCategories[category].selfTransfer)
    }
  ]

  const pieChartOptions = {
    cutout: 120,
    responsive: true,
    maintainAspectRatio: false,
    events: ["click"],
    onClick: (e, element) => {
      let array = dataMap.slice(0, 5);
      let total = array.reduce((accumulator, object) => {
        return accumulator + object.total;
      }, 0);;
      let amount = element[0].element.$context.parsed;
      let percentage = Utils.formatDecimalPercentage(amount/total);
      
      setActiveChartArea({ index: element[0].element.$context.index, label: percentage});
    },
    plugins: {
      tooltip: {
        enabled: false
      },
      legend: {
        display: false
      },
    }
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

  dataMap.forEach((element, i) => {
    if(i < 5) {
      pieData.push(element.total);
      pieLabels.push(element.label);
      listData.push({
        header: element.label,
        detail: Utils.formatCurrency(Currency.format, Currency.symbol, element.total),
        legendColor: pieChartColors[i],
        isActive: i === activeChartArea.index ? true : false
      })
    }
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
          <div className="doughnut-chart">
            {!Utils.isFieldEmpty(activeChartArea.index) && 
              <img src="/assets/icons/close-square.svg" alt="Close" className="reset-chart"
                onClick={() => setActiveChartArea({ index: null, label: "100%" })} />
            }
            <Doughnut data={{
              labels: pieLabels,
              datasets: [
                {
                  data: pieData,
                  backgroundColor: pieChartColors
                }
              ]
            }} options={pieChartOptions} />
            <p className="doughnut-chart-center-label">{activeChartArea.label}</p>
          </div>
          <List listClass="list-col" listItemClass="list-item-row" headerClass={"list-header-small list-header-light list-header-row"}
            listDetailClass="text-medium" listContent={listData} />
        </div>
        <div className="button-row-end">
          <button className="button-link-lighter button-link-bold button-text-large">See all</button>
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
            <h2 className="text-dark">Top Beneficiaries</h2>
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