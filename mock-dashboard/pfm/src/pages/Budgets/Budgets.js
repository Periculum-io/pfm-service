import React, { useState } from "react";
import List from "../../components/List/List";
import NavBar from "../../components/NavBar/NavBar";
import { BudgetSpending, Currency } from "../../library/Data";
import Utils from "../../library/Utils";
import './Budgets.css';
import { Chart as 
  ChartJS, 
  ArcElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip, 
  Legend } from 'chart.js';
import { Doughnut } from 'react-chartjs-2';
import Modal from 'react-modal';
import { BudgetView } from "../../library/Variables";
import BudgetForm from "./Sections/BudgetForm";
import CategoryCard from "./Sections/CategoryCard";
import CategoryTransactions from "../../components/Modal/CategoryTransactions";

if (process.env.NODE_ENV !== 'test') {
  Modal.setAppElement('#root');
}

function Budgets() {
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
  let pieChartColors = [];
  let dataMap = [
    {
      header: 'Total Budget available',
      detail: Utils.checkNullNumber(BudgetSpending.totalBudgetAvailable),
      legendColor: "#D8E0E6"
    },
    {
      header: 'Total spent so far',
      detail: Utils.checkNullNumber(BudgetSpending.totalSpentSoFar),
      legendColor: "#FF725E"
    }
  ]

  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [budgetView, setBudgetView] = useState(BudgetView.INITIAL);
  const [category, setCategory] = useState({ name: "", amount: 0, budget: 0 });
  const pieChartOptions = {
    cutout: 50,
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      tooltip: {
        callbacks: {
          label: function(context) {
            let dataset = context.dataset.data;
            let amount = Utils.formatCurrency(Currency.format, Currency.symbol, dataset[context.dataIndex]);
      
            return amount;
          }
        }
      },
      legend: {
        display: false
      },
    }
  }
  const customStyles = {
    content: {
      transition: '0.125s ease-in-out',
      padding: '0',
      fontFamily: "'Helvetica Neue', sans-serif",
    },
    overlay: {
      zIndex: 1000,
      position: 'absolute'
    }
  };

  dataMap.forEach((element, i) => {
    pieData.push(element.detail);
    pieLabels.push(element.header);
    pieChartColors.push(element.legendColor);
    element.detail = Utils.formatCurrency(Currency.format, Currency.symbol, element.detail);
  })

  const navbarContent = <>
    <div className="header-row">
      <h1 className="text-lighter">Budget</h1>
      <button className="button-square button-white" onClick={() => setBudgetView(BudgetView.ADD_BUDGET)}>+ Add new budget</button>
    </div>
    <div className="navbar-budget-stats-container">
      <div className="navbar-budget-stats-list-container">
        <List listClass="list-row" listItemClass="list-item-col" 
          headerClass={"text-medium list-header-small list-header-light list-header-row"}
          listDetailClass="text-dark list-detail-big list-detail-bold" listContent={[ 
            { 
              header: "Monthly Budget Set", 
              detail: Utils.formatCurrency(Currency.format, Currency.symbol, Utils.checkNullNumber(BudgetSpending.monthlyBudgetSet))
            } 
          ]} />
        <div className="navbar-budget-stats-legend-list-container">
          <List listClass="list-row" listItemClass="list-item-col" 
            headerClass={"text-medium list-header-small list-header-light list-header-row"}
            listDetailClass="text-dark list-detail-big list-detail-bold" listContent={dataMap} />
        </div>
      </div>
      <div className="doughnut-chart">
        <Doughnut data={{
          labels: pieLabels,
          datasets: [
            {
              data: pieData,
              backgroundColor: pieChartColors
            }
          ]
        }} options={pieChartOptions} />
      </div>
    </div>
    
  </>

  function afterOpenModal(){}

  function openModal() {
    setModalIsOpen(true);
  }

  function closeModal() {
    setModalIsOpen(false);
  }

  const handleCategoryCallback = (category) => {
    setCategory(category);
    openModal();
  }

  const handleBudgetFormCallback = () => {
    setBudgetView(BudgetView.INITIAL);
  }

  if(!Utils.isFieldEmpty(BudgetSpending)) {
    if(budgetView === BudgetView.INITIAL) {
      content = <>
        <div className="header-row">
          <div className="header-row-stats-container">
            <h2 className="text-dark">Budget Categories</h2>
            <p className="text-light">Timeline set: <span className="text-dark text-medium-bold">
              {Utils.formatLongDate(BudgetSpending.startDate)} - {Utils.formatLongDate(BudgetSpending.endDate)}
            </span></p>
          </div>
          <button className="button-square button-solid" onClick={() => setBudgetView(BudgetView.EDIT_BUDGET)}>Edit Budget</button>
        </div>
        <div className="budget-categories-container">
          {!Utils.isFieldEmpty(BudgetSpending.categories) &&
            (BudgetSpending.categories).map((element, i) => {
              return <CategoryCard category={element} key={i} 
                parentCallback={(category) => handleCategoryCallback(category)} />
            })
          }
        </div>
      </>
    } else if(budgetView === BudgetView.EDIT_BUDGET) {
      content = <BudgetForm data={BudgetSpending} parentCallback={() => handleBudgetFormCallback()} buttonLabel={"Save"} />
    } else if(budgetView === BudgetView.ADD_BUDGET) {
      content = <BudgetForm parentCallback={() => handleBudgetFormCallback()} buttonLabel={"Create budget"} />
    }
  } else {
    content = <BudgetForm parentCallback={() => handleBudgetFormCallback()} buttonLabel={"Create budget"} />
  }

  return (
    <>
      <NavBar content={navbarContent} contentClass="navbar-budget-stats" />
      <div className="budgets-body">
        <Modal isOpen={modalIsOpen} onAfterOpen={afterOpenModal} onRequestClose={closeModal} style={customStyles}>
          <CategoryTransactions category={category} close={closeModal} />
        </Modal>
        {content}
      </div>
    </>
  )
}

export default Budgets;