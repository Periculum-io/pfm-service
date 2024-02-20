import React, { useState } from "react";
import { BudgetSpending } from "../../../library/Data";
import Utils from "../../../library/Utils";
import CategoryCard from "./CategoryCard";
import Modal from 'react-modal';
import CategoryTransactions from "../../../components/Modal/CategoryTransactions";

function AllCategories(props) {
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [category, setCategory] = useState({ name: "", amount: 0, budget: 0 });
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

  const backButton = <button className="button-back" onClick={() => props.parentCallback()}>
    <img src="/assets/icons/arrow-left.svg" alt="" />
    Back
  </button>

  const allCategoriesContent = !Utils.isFieldEmpty(BudgetSpending.categories) &&
    (BudgetSpending.categories).map((element, i) => {
      return <CategoryCard category={element} key={i} parentCallback={(category) => handleCategoryCallback(category)} />
    })

  const handleCategoryCallback = (category) => {
    setCategory(category);
    openModal();
  }

  function afterOpenModal(){}

  function openModal() {
    setModalIsOpen(true);
  }

  function closeModal() {
    setModalIsOpen(false);
  }

  return <div>
    <Modal isOpen={modalIsOpen} onAfterOpen={afterOpenModal} onRequestClose={closeModal} style={customStyles}>
      <CategoryTransactions category={category} close={closeModal} />
    </Modal>
    {backButton}
    <div className="budget-categories-container">
      {allCategoriesContent}
    </div>
  </div>
}

export default AllCategories;