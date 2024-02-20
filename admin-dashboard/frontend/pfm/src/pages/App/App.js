import './App.css';
import SideBar from "../../components/SideBar/SideBar";
import Login from "../Login/Login";
import Signup from "../SignUp/SignUp";
import Error from "../Error/Error";
import NotFound from "../NotFound/NotFound";
import Home from"../Home/Home";
import Budgets from '../Budgets/Budgets';
import Financial from '../Financial/Financial';
import { KeycloakContext } from '../..';
import { BrowserRouter as Router, Routes, Route, useNavigate, useLocation } from 'react-router-dom';
import Spinner from "../../components/Spinner/Spinner";
import React, { useState, useEffect } from 'react';
import Utils from '../../library/Utils';

function App() {
  let content = <div className='app-loading-container'><Spinner /></div>;

  const location = useLocation();
  const navigate = useNavigate();
  const keycloakContext = React.useContext(KeycloakContext);
  const [isFinishedLoading, setIsFinishedLoading] = useState(false);

  useEffect(() => {
    // check for valid token
    // if(Utils.isFieldEmpty(keycloakContext.token) && keycloakContext.authenticated === false) {
    //   navigate("/");
    // }
    // else if(!Utils.isFieldEmpty(keycloakContext.token) && keycloakContext.authenticated === true) {
    //   if (["/login", "/", "/signup"].includes(location.pathname)) {
    //     navigate('/home');
    //   }
    // }

    if(isFinishedLoading === false && !Utils.isFieldEmpty(keycloakContext)) {
      setIsFinishedLoading(true);
    }
  }, [keycloakContext, isFinishedLoading]);

  if(isFinishedLoading) {
    content = <Router>
      <Routes>
        <Route path="/" element={
          <div className="parent-body">
            <Login />
          </div>
        } />
        <Route path="/login" element={
          <div className="parent-body">
            <Login />
          </div>
        } />
        <Route path="/signup" element={
          <div className="parent-body">
            <Signup />
          </div>
        } />
        <Route path="/home" element={
          <div className="parent-body">
            <SideBar />
            <div className="main-body" >
              <Home />
            </div>
          </div>
        } />
        <Route path="/budgets" element={
          <div className="parent-body">
            <SideBar />
            <div className="main-body" >
              <Budgets />
            </div>
          </div>
        } />
        <Route path="/financial" element={
          <div className="parent-body">
            <SideBar />
            <div className="main-body" >
              <Financial />
            </div>
          </div>
        } />
        <Route path="/error" element={<Error />} />
        <Route path="*" element={<NotFound />} />
        <Route path="/404" element={<NotFound />} />
      </Routes>
    </Router>
  }

  return (
    content
  );
}

export default App;