# 💰 Cashio - Personal Finance Tracker

Cashio is a Personal Finance Tracker Web Application developed using Java, JSP, Servlets, JDBC, and MySQL. It helps users manage their income, expenses, budgets, and financial reports through an easy-to-use dashboard.

---

## 🚀 Features

### 👤 User Management

* User Registration
* User Login & Logout
* Profile Management
* Update Email & Phone Number
* Change Password
* Forgot Password Support

### 💵 Income Management

* Add Income
* Edit Income
* Delete Income
* Income History

### 💸 Expense Management

* Add Expenses
* Edit Expenses
* Delete Expenses
* Expense History

### 📊 Budget Management

* Set Monthly Budget
* Track Spending
* Budget Monitoring

### 📈 Reports & Analytics

* Financial Reports
* Income Summary
* Expense Summary
* Savings Overview

### 📁 Additional Features

* PDF Report Generation
* Dashboard Statistics
* Profile Picture Upload
* Session Management

---

## 🛠️ Technologies Used

### Frontend

* HTML
* CSS
* JavaScript
* JSP

### Backend

* Java
* Servlets
* JDBC

### Database

* MySQL

### Server

* Apache Tomcat

### Tools

* Eclipse IDE
* Git
* GitHub
* MySQL Workbench

---

## 📂 Project Structure

src/main/java

* Controllers (Servlets)
* DAO Classes
* Models
* Database Configuration

src/main/webapp

* JSP Pages
* UI Components
* Static Resources

BudgetTrackerDB.sql

* Database Script

---

## 🗄️ Database Setup

1. Open MySQL Workbench
2. Create Database

```sql
CREATE DATABASE budget_tracker;
```

3. Run the SQL script:

```text
BudgetTrackerDB.sql
```

4. Update database credentials in:

```text
DBConnection.java
```

Example:

```java
String url = "jdbc:mysql://localhost:3306/budget_tracker";
String username = "root";
String password = "YOUR_PASSWORD";
```

---

## ▶️ How to Run

1. Clone the repository

```bash
git clone https://github.com/Rasika06-darekar/Cashio.git
```

2. Import project into Eclipse

3. Configure MySQL Database

4. Run Apache Tomcat Server

5. Open Browser

```text
http://localhost:8080/Cashio/login.jsp
```

## 🎯 Future Enhancements

* Email Notifications
* Export Reports to Excel
* Advanced Charts & Analytics
* Mobile Responsive Design
* Cloud Deployment
* AI-Based Expense Insights

---

## 👩‍💻 Developer

**Rasika Darekar**

GitHub:
https://github.com/Rasika06-darekar

---

## ⭐ Project Status

Completed and actively maintained for learning and portfolio purposes.

