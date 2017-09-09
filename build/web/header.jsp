<!-- bootstrap responsive multi-level dropdown menu -->
<nav class="navbar navbar-inverse" style="background-color: saddlebrown; margin-bottom: 2px; color: black;" role="navigation">
      <div class="container-fluid">
         <!-- header -->
         <div class="navbar-header" style="width:20%;">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#multi-level-dropdown">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            </button>
             <a class="navbar-brand" href="Home.jsp" style="width:100%; font-family: cursive;font-weight: bolder;text-align: center;background-color: tomato; color: Black;border-radius: 5em;">SmartHotel</a>
         </div>
         <!-- menus -->
         <div class="collapse navbar-collapse" id="multi-level-dropdown">
            <ul class="nav navbar-nav">
            <li><a href="home.jsp">Home</a></li>
            <li class="dropdown">
               <a href="#" class="dropdown-toggle" data-toggle="dropdown">Master <b class="caret"></b></a>
               <ul class="dropdown-menu">
                   <% if(session.getAttribute("roleid") != null && ((Integer) session.getAttribute("roleid")) == 1){ %>
               <li class="dropdown-submenu">
                  <a href="#" tabindex="-1"><span class="glyphicon glyphicon-plus"></span> Add</a>
                  <ul class="dropdown-menu">
                  <li ><a href="AddCategory.jsp">Category</a></li>                          
                  <li ><a href="AddSubCategory.jsp">Sub-Category</a></li>
                  <li><a href="AddMenuItem.jsp" accesskey="m">MenuItem</a></li>
<!--                  <li><a href="#">Table Lamps</a></li>-->
<!--                  <li class="dropdown-submenu">
                     <a href="#" tabindex="-1">Floor Lamps</a>
                     <ul class="dropdown-menu">
                     <li><a href="#">Living Room</a></li>
                     <li><a href="#">Bed Room</a></li>
                     <li><a href="#">Garden Lamps</a></li>
                     </ul>
                  </li>-->
                  </ul>
               </li>
               <% } %>
               <li ><a href="AddMaterialStock.jsp">Material</a></li>
               <li ><a href="SetSpecialMenuItem.jsp">Special MenuItem</a></li>
               <li ><a href="AddMessage.jsp"><span class="glyphicon glyphicon-comment"></span> Messages</a></li>
               </ul>
            </li>
            <li class="dropdown">
               <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-list"></span> Order<b class="caret"></b></a>
               <ul class="dropdown-menu">
                   <li ><a href="GetOrder.jsp"><span accesskey="o" class="glyphicon glyphicon-edit"></span> Get Order</a></li>
                 <li ><a href="TableDashboard.jsp" target="_blank"><span accesskey="c" class="glyphicon glyphicon-list-alt"></span> Current Order List</a></li>
                 <li ><a href="TableShift.jsp"><span accesskey="o" class="glyphicon glyphicon-edit"></span> Table Shift</a></li>
                 <li ><a href="Review.jsp"><span accesskey="r" class="glyphicon glyphicon-list-alt"></span>Customer Review</a></li>
               </ul>
            </li>
            <li class="dropdown">
               <a href="#" class="dropdown-toggle" data-toggle="dropdown">Purchase<b class="caret"></b></a>
               <ul class="dropdown-menu">
                   <li ><a href="AddPurchaseMaterial.jsp" accesskey="p">Purchase Material</a></li>
                   <li ><a href="MenuItemComposition.jsp" accesskey="e">Menu Item Expense Material</a></li>
                   <li ><a href="CounterSellStock.jsp" accesskey="e">Godown stock</a></li>
                   <li ><a href="AddExpenceMaterial.jsp" accesskey="e">Clear stock</a></li>
               </ul>
            </li>
              <li class="dropdown">
               <a href="#" class="dropdown-toggle" data-toggle="dropdown">Payment<b class="caret"></b></a>
               <ul class="dropdown-menu">
                   <li ><a href="MakePayment.jsp">Make Payment</a></li>
               </ul>
            </li>
            <li class="dropdown">
               <a href="#" class="dropdown-toggle" data-toggle="dropdown">Reports<b class="caret"></b></a>
               <ul class="dropdown-menu">
               <li ><a href="ReportController?act=1&submodule=datewise&isDateOnly=true" accesskey="d" target="_blank"> Daily Order Report</a></li>
               <li ><a href="SelectDateAndAllTableList.jsp"> Table Wise Report</a></li>
               <li class="dir"><a href="paymentmodereport.jsp"> Payment Mode Report</a></li>
               <!--<li ><a href="DateWiseKOT.jsp"> KOT report</a></li>-->
               <li ><a href="DateWiseStock.jsp"> Stock report</a></li>
               <li ><a href="SpecialReportSelectDate.jsp"> Order Report (For Hour Diff)</a></li>
               <li class="dropdown-submenu">
                  <a href="#" tabindex="-1">MenuItem</a>
                  <ul class="dropdown-menu">
               <li ><a href="ReportController?act=1&submodule=datewisemenuitemrecord" accesskey="d" target="_blank"> Daily Report</a></li>
               <li class="dir"><a href="DateWiseMenuItem.jsp" > Date Report</a></li>
               <li ><a href="MonthlyAmountDetails.jsp"> Monthly Audit report</a></li>
               <li ><a href="CategoryReportSelectDate.jsp">Category Wise Report </a></li>
               <li ><a href="SelectMenuItemAndDate.jsp">Weekly Report </a></li>
               <li ><a href="SelectCategoryAndDate.jsp">Category Weakly Report </a></li>
<!--                  <li ><a href="SelectDate.jsp">Date Report</a></li>
                  <li ><a href="SelectMonthAndYear.jsp" > Month Report</a></li>
                  <li ><a href="SelectYear.jsp" >Year Report</a></li>
                  <li><a href="#">Ceiling Lamps</a></li>
                  <li><a href="#">Table Lamps</a></li>-->
<!--                  <li class="dropdown-submenu">
                     <a href="#" tabindex="-1">Floor Lamps</a>
                     <ul class="dropdown-menu">
                     <li><a href="#">Living Room</a></li>
                     <li><a href="#">Bed Room</a></li>
                     <li><a href="#">Garden Lamps</a></li>
                     </ul>
                  </li>-->
                  </ul>
               </li>
               <li class="dropdown-submenu">
                  <a href="#" tabindex="-1">Sale</a>
                  <ul class="dropdown-menu">
                  <li ><a href="SelectDate.jsp">Date Report</a></li>
                  <li ><a href="SelectMonthAndYear.jsp" > Month Report</a></li>
                  <li ><a href="SelectYear.jsp" >Year Report</a></li>
<!--                  <li><a href="#">Ceiling Lamps</a></li>
                  <li><a href="#">Table Lamps</a></li>-->
<!--                  <li class="dropdown-submenu">
                     <a href="#" tabindex="-1">Floor Lamps</a>
                     <ul class="dropdown-menu">
                     <li><a href="#">Living Room</a></li>
                     <li><a href="#">Bed Room</a></li>
                     <li><a href="#">Garden Lamps</a></li>
                     </ul>
                  </li>-->
                  </ul>
               </li>
               <li class="dropdown-submenu">
                  <a href="#" tabindex="-1">Purchase</a>
                  <ul class="dropdown-menu">
                  <li><a href="PurchaseMaterialName.jsp"> Material Report</a></li>
                  <li><a href="SelectPurchaseDate.jsp">Date Report</a></li>
                  <li><a href="SelectPurchaseMonth.jsp">Month Report</a></li>
                  <li><a href="SelectPurchaseYear.jsp">Year Report</a></li>
                  </ul>
               </li>
                 <li class="dropdown-submenu">
                  <a href="#" tabindex="-1">Borrow</a>
                  <ul class="dropdown-menu">
                   <li><a href="ReportController?act=1&submodule=dailyborrow" accesskey="d" target="_blank"> Daily Report</a></li>
                   <li><a href="BorrowDate.jsp" > Date Report</a></li>
                   <li><a href="SelectBorrowMonth.jsp" > Month Report</a></li>
                  </ul>
               </li>
<!--                 <li class="dropdown-submenu">
                  <a href="#" tabindex="-1">Expense</a>
                  <ul class="dropdown-menu">
                  <li><a href="ExpenseMaterialName.jsp">Material Report</a></li>
                  <li><a href="ExpenseMaterialDate.jsp">Date Report</a></li>
                  <li><a href="ExpenseMaterialMonth.jsp">Month Report</a></li>
                  </ul>
               </li>-->
                 <li class="dropdown-submenu">
                  <a href="#" tabindex="-1">Payment</a>
                  <ul class="dropdown-menu">
                  <li><a href="SelectPaymentDate.jsp">Date Report </a></li>
                  <li><a href="SelectPaymentEmployee.jsp">Employee Report </a></li>
                  </ul>
               </li>
                 <li ><a href="CancelOrderDetails.jsp"> Cancel Report</a></li>
                 <li ><a href="ReviewReport.jsp"> Review Report</a></li>
               </ul>
            </li>
            <li class="dropdown">
               <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> Settings <b class="caret"></b></a>
               <ul class="dropdown-menu">
                 <li ><a href="AddEmployeeDetails.jsp">Employee Profile</a></li>
                   <% if(session.getAttribute("roleid") != null && ((Integer) session.getAttribute("roleid")) == 1){ %>
                    <li><a href="AddUser.jsp">Create New User</a></li>
                  <li ><a href="SetCategoryPrinter.jsp">Set Category Printer</a></li>
                 <li ><a href="MasterSettingsForm.jsp"><span class="glyphicon glyphicon-cog"></span> Master Settings</a></li>
                    <% } %>
                 <li ><a href="UserController?act=5&submodule=dbbackup">DB Backup</a></li>
               </ul>
            </li>
            <li ><a href="login.jsp?logout=true"><span class="glyphicon glyphicon-log-out" accesskey="l"></span> Log Out</a></li>
            </ul>
         </div>
      </div>
   </nav>

<!--============================================================================================================================-->
<!--<div>
    <div class="rmm style" style="width: 90%;">
        <ul style="background-color: orangered ;width: 100%;">
            <li class="current-menu-item"><a href="home.jsp"><span class="glyphicon glyphicon-home"></span> Home</a></li>
            <li><a href="#"><span class="glyphicon glyphicon-king"></span> Master</a>
                <ul>
                    <li><a href="#"><span class="glyphicon glyphicon-plus"></span> Add</a>
                        <ul>
                            <li ><a href="AddCategory.jsp">Category</a></li>                          
                            <li ><a href="AddSubCategory.jsp">Sub-Category</a></li>
                            <li ><a href="AddMenuItem.jsp" accesskey="m">MenuItem</a></li>
                        </ul>
                        <li ><a href="AddMaterialStock.jsp">Material</a></li>
                        <li ><a href="AddMessage.jsp"><span class="glyphicon glyphicon-comment"></span> Messages</a></li>
                </ul>
            </li>
            <li><a href="#"><span class="glyphicon glyphicon-list"></span> Order</a>
                <ul>
                    <li class="dir"><a href="GetOrder.jsp"><span accesskey="o" class="glyphicon glyphicon-edit"></span> Get Order</a></li>
                    <li class="dir"><a href="TableDashboard.jsp" target="_blank"><span accesskey="c" class="glyphicon glyphicon-list-alt"></span> Current Order List</a></li>
                    <li class="dir"><a href="TableShift.jsp"><span accesskey="o" class="glyphicon glyphicon-edit"></span> Table Shift</a></li>
                    <li class="dir"><a href="Review.jsp"><span accesskey="r" class="glyphicon glyphicon-list-alt"></span>Customer Review</a></li>
                </ul>
            </li>
            <li><a href="#">Purchase</a>
                <ul>
                    <li class="dir" ><a href="AddPurchaseMaterial.jsp" accesskey="p">Purchase Material</a></li>
                    <li class="dir" ><a href="MenuItemComposition.jsp" accesskey="e">Menu Item Expense Material</a></li>
                    <li class="dir" ><a href="CounterSellStock.jsp" accesskey="e">Godown stock</a></li>
                    <li class="dir" ><a href="AddExpenceMaterial.jsp" accesskey="e">Clear stock</a></li>
                </ul>
            </li>
            <li><a href="#"><span class="glyphicon glyphicon-piggy-bank"></span> Payment</a>
                <ul>
                    <li class="dir" accesskey="y"><a href="MakePayment.jsp">Make Payment</a></li>
                </ul>
            </li>
            <li><a href="#"><span class="glyphicon glyphicon-tasks"></span> Reports</a>
                <ul>
                    <li class="dir"><a href="ReportController?act=1&submodule=datewise" accesskey="d" target="_blank"> Daily Order Report</a></li>
                    <li class="dir"><a href="SelectDateAndAllTableList.jsp"> Table Wise Report</a></li>
                    <li class="dir"><a href="DateWiseKOT.jsp"> KOT report</a></li>
                    <li class="dir"><a href="DateWiseStock.jsp"> Stock report</a></li>
                    <li><a href="#">Sales</a>
                        <ul>
                            <li class="dir"><a href="SelectDate.jsp">Date Report</a></li>
                            <li class="dir"><a href="SelectMonthAndYear.jsp" > Month Report</a></li>
                            <li class="dir"><a href="SelectYear.jsp" >Year Report</a></li>
                        </ul>
                    </li>
                    <li><a href="#">Purchase</a>
                        <ul>
                            <li class="dir"><a href="PurchaseMaterialName.jsp"> Material Report</a></li>
                            <li class="dir"><a href="SelectPurchaseDate.jsp">Date Report</a></li>
                            <li class="dir"><a href="SelectPurchaseMonth.jsp">Month Report</a></li>
                            <li class="dir"><a href="SelectPurchaseYear.jsp">Year Report</a></li>
                        </ul>
                    </li>
                    <li><a href="#">Borrow</a>
                        <ul>
                            <li class="dir"><a href="ReportController?act=1&submodule=dailyborrow" accesskey="d" target="_blank"> Daily Report</a></li>
                            <li class="dir"><a href="BorrowDate.jsp" > Date Report</a></li>
                            <li class="dir"><a href="SelectBorrowMonth.jsp" > Month Report</a></li>
                            <li class="dir"><a href="SelectYear.jsp" >Year Report</a></li>
                        </ul>
                    </li>
                    <li><a href="#">Expense</a>
                        <ul>
                            <li class="dir"><a href="ExpenseMaterialName.jsp">Material Report</a></li>
                            <li class="dir"><a href="ExpenseMaterialDate.jsp">Date Report</a></li>
                            <li class="dir"><a href="ExpenseMaterialMonth.jsp">Month Report</a></li>
                        </ul>
                    </li>

                    <li><a href="#">Payment</a>
                        <ul>
                            <li class="dir"><a href="SelectPaymentDate.jsp">Date Report </a></li>
                            <li class="dir"><a href="SelectPaymentEmployee.jsp">Employee Report </a></li>
                        </ul>
                    </li>
                    <li class="dir"><a href="CancelOrderDetails.jsp"> Cancel Report</a></li>
                    <li class="dir"><a href="ReviewReport.jsp"> Review Report</a></li>
                </ul>
            </li>
            <li><a href="#"><span class="glyphicon glyphicon-user"></span> Settings </a>
                <ul>
                    <li><a href="AddUser.jsp">Create User</a></li>
                    <li><a href="AddEmployeeDetails.jsp">Employee Profile</a></li>
                    <li ><a href="StockMasterForm.jsp"><span class="glyphicon glyphicon-cog"></span> Master Settings</a></li>
                    <li ><a href="UserController?act=5&submodule=flushdb">Flush DB</a></li>
                    <li><a href="Review.jsp">Add Review</a></li>
                </ul>
            </li>
            <li><a href="login.jsp?logout=true"><span class="glyphicon glyphicon-log-out" accesskey="l"></span> Logout</a></li>
        </ul>
    </div>
</div>
<div style="text-align: center;width: 90%;margin-left: auto;margin-right: auto;">
    <img src="images/header7.jpg" style="height: 150px; width: 100%;" alt="Header Image" />
</div>-->
