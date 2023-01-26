import React, { useEffect, useRef, useState } from "react";
import Bar from "../../../components/Bar/Bar";
import List from "../../../components/List/List";
import { Currency } from "../../../library/Data";
import Utils from "../../../library/Utils";
import "./CategoryCard.css";
import { Chart as 
  ChartJS, 
  ArcElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip, 
  Legend } from 'chart.js';
import { Doughnut } from 'react-chartjs-2';

function CategoryCard(props) {
  ChartJS.register(
    CategoryScale,
    LinearScale,
    ArcElement,
    Title,
    Tooltip,
    Legend,
  );

  let exceededOrReached = "reached";

  const category = props.category;
  const isBudgetMet = category.amountSpent >= category.budgetSet ? true : false;
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const ref = useRef(null);
  const pieChartColors = [category.color, "#D8E0E7"];
  const pieLabels = ["Amount Spent", "Budget Set"];
  const pieData = [category.amountSpent, category.budgetSet];
  const pieChartOptions = {
    cutout: 50,
    responsive: true,
    maintainAspectRatio: false,
    events: [],
    plugins: {
      tooltip: {
        enabled: false
      },
      legend: {
        display: false
      },
    }
  }

  if(category.amountSpent > category.budgetSet) {
    exceededOrReached = "exceeded";
  }

  const menuContainer = !Utils.isFieldEmpty(props.parentCallback)
    ? <div className="category-card-menu-container" ref={ref}>
        <img src="/assets/icons/menu.svg" alt="" onClick={() => setIsMenuOpen(!isMenuOpen)} />
        {isMenuOpen &&
          <div className="category-card-menu" onClick={() => props.parentCallback(category)}>
            View Transactions
          </div>
        }
      </div>
    : null;

  const budgetExceededContent = isBudgetMet === true 
    ? <div className="budget-exceeded-container">
        <img src="/assets/icons/danger.svg" alt="" />
        <p>Budget limit {exceededOrReached}</p>
      </div>
    : null;

  useEffect(() => {
    function handleClickOutside(event) {
      if (ref.current && !ref.current.contains(event.target)) {
        setIsMenuOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
  }, [ref])

  return (
    <div className="category-card-body">
      <div className="header-row">
        <h3 className="text-dark">{category.name}</h3>
        {menuContainer}
      </div>
      <div className="category-card-list-doughnut-container">
        <List listClass="list-row" listItemClass="list-item-col" headerClass={"text-medium list-header-small list-header-light list-header-row"}
          listDetailClass="text-dark list-detail-big list-detail-bold" listContent={[
            {
              header: 'Amount Spent',
              detail: Utils.formatCurrency(Currency.format, Currency.symbol, category.amountSpent)
            }
          ]} />
        <div className="category-card-doughnut-container">
          <p className="category-chart-center-label">{Utils.formatDecimalPercentage(category.amountSpent/category.budgetSet)}</p>
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
        <List listClass="list-row" listItemClass="list-item-col" headerClass={"text-medium list-header-small list-header-light list-header-row"}
          listDetailClass="text-dark list-detail-big list-detail-bold" listContent={[
            {
              header: 'Budget Set',
              detail: Utils.formatCurrency(Currency.format, Currency.symbol, category.budgetSet)
            }
          ]} />
      </div>
      {budgetExceededContent}
    </div>
  )
}

export default CategoryCard;