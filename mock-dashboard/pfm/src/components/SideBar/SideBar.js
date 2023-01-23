import React, { useState, useEffect, useRef } from "react";
import './SideBar.css';
import SideBarContent from "./SideBarContent";

function SideBar() {
  const [burger, setBurger] = useState(false);
  const sidebarRef = useRef(null);

  useEffect(() => {
    function handleClickOutside(event) {
      if (sidebarRef.current && !sidebarRef.current.contains(event.target)) {
        setBurger(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside);

  }, [sidebarRef]);

  return (
    <div className='sidebar-main' ref={sidebarRef} >
      <div className="burger-container">
        <button onClick={() => setBurger(!burger)} className="burger-button">{
          burger === false 
          ? <img src={'/assets/icons/open-square.svg'} alt="open" className="burger-icon" /> 
          : <img src={'/assets/icons/close-square.svg'} alt="close" className="burger-icon" />
        }</button>
        {burger === true &&
          <div className="sidebar-burger">
            <SideBarContent />
          </div>
        }
      </div>
      <div className="sidebar">
        <SideBarContent />
      </div>
    </div>
  )
}

export default SideBar;