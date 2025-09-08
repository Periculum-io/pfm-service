import React, { useMemo, useState } from "react";
import './Financial.css';
import NavBar from "../../components/NavBar/NavBar";
import FinancialCard from "./Sections/FinancialCard";
import { FinancialViews } from "../../library/Variables";
import { BudgetCategoriesTransactions, Currency } from "../../library/Data";
import { Table } from "../../components/Table/Table";
import Utils from "../../library/Utils";
import Modal from 'react-modal';
import AddFinancialGoal from "../../components/Modal/AddFinancialGoal";

if (process.env.NODE_ENV !== 'test') {
  Modal.setAppElement('#root');
}

function Financial() {
  let content = null;

  const [view, setView] = useState(FinancialViews.INITIAL);
  const [modalIsOpen, setModalIsOpen] = useState(false);

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

  const goalsData = {
    name: "My tech gadgets",
    spent: 300000,
    total: 500000,
    color: "#0CBC8B"
  };

  const emergencyData = {
    name: "Emergency Balance",
    spent: 100000,
    total: 500000,
    color: "#0CBC8B"
  };

  const backButton = <button className="button-back" onClick={() => setView(FinancialViews.INITIAL)}>
    <img src={`${process.env.PUBLIC_URL}/assets/icons/arrow-left.svg`}  alt="" />
    Back
  </button>

  const navbarContent = <div className="header-row">
    <div>
      <h1 className="text-lighter">Financial Goals</h1>
      <p className="text-lighter">Track and fulfill your financial goals</p>
    </div>
    <button className="button-square button-white" onClick={() => openModal()}>+ Add new goal</button>
  </div>

  const theadersTransactions = useMemo(() => [
    { 
      id: 'icon',
      Cell: data => {
        return (
          <img className="financial-transaction-icon" src={`${process.env.PUBLIC_URL}/assets/icons/arrow-up-solid-green.svg`}  alt="" />
        );
      },
      disableSortBy: true,
    },
    { 
      id: 'name',
      Cell: data => {
        return (
          <div className="transactions-name-col">
            <p className="text-medium-bold text-dark">{(data.row.original.name).toUpperCase()}</p>
            <p className="text-dark">{data.row.original.status}</p>
          </div>
        );
      },
      disableSortBy: true,
    },
    { 
      id: 'amount',
      Cell: data => {
        return (
          <div className="transactions-amount-col">
            <p className="text-dark text-medium-bold">{Utils.formatCurrency(Currency.format, Currency.symbol, data.row.original.amount)}</p>
            <p className="text-dark">{Utils.formatLongDate(data.row.original.date)}</p>
          </div>
        );
      },
      disableSortBy: true,
    }]
  )

  const handleGoalCallback = () => {
    setView(FinancialViews.GOALS);
  }

  const handleEmergencyCallback = () => {
    setView(FinancialViews.EMERGENCY);
  }

  function afterOpenModal(){}

  function openModal() {
    setModalIsOpen(true);
  }

  function closeModal() {
    setModalIsOpen(false);
  }

  if(view === FinancialViews.INITIAL) {
    content = <>
      <h2 className="text-dark">Goals</h2>
      <FinancialCard data={goalsData} parentCallback={(data) => handleGoalCallback(data)} />
      <h2 className="text-dark">Emergency Funds</h2>
      <FinancialCard type="nested-bar" data={emergencyData} parentCallback={(data) => handleEmergencyCallback(data)} />
    </>
  } else if(view === FinancialViews.GOALS) {
    content = <>
      {backButton}
      <FinancialCard data={goalsData} />
      <h2 className="text-dark">Transactions</h2>
      <div className="financial-transactions-table-container">
        <Table data={BudgetCategoriesTransactions} columns={theadersTransactions} showHeader={false} />
      </div>
    </>
  } else if(view === FinancialViews.EMERGENCY) {
    content = <>
      {backButton}
      <br/>
      <h2 className="text-dark">Emergency Fund</h2>
      <FinancialCard type="nested-bar" data={emergencyData} />
      <h2 className="text-dark">Transactions</h2>
      <div className="financial-transactions-table-container">
        <Table data={BudgetCategoriesTransactions} columns={theadersTransactions} showHeader={false} />
      </div>
    </>
  }

  return (
    <>
      <NavBar content={navbarContent} contentClass="navbar-financial-goals" />
      <div className="financial-body">
        <Modal isOpen={modalIsOpen} onAfterOpen={afterOpenModal} onRequestClose={closeModal} style={customStyles}>
          <AddFinancialGoal close={closeModal} />
        </Modal>  
        {content}
      </div>
    </>
  )
}

export default Financial;