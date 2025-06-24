import streamlit as st
import pandas as pd
import psycopg2
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime
from streamlit_option_menu import option_menu

# ----------------------
# PAGE CONFIGURATION
# ----------------------

st.set_page_config(
    page_title="HR Analytics Dashboard",
    layout="wide",
    page_icon="📈"
)

# ----------------------
# HEADER SECTION
# ----------------------
st.markdown("""
<style>
    .main-title {
        font-size:42px !important;
        font-weight:700;
        color: #2c3e50;
    }
    .sub-title {
        font-size:22px;
        color: #7f8c8d;
    }
</style>
""", unsafe_allow_html=True)

st.markdown('<p class="main-title">📊 HR Analytics Dashboard</p>', unsafe_allow_html=True)
st.markdown('<p class="sub-title">Powered by PostgreSQL + Python + Streamlit</p>', unsafe_allow_html=True)

# ----------------------
# DB CONNECTION FUNCTION
# ----------------------
def get_connection():
    return psycopg2.connect(
        dbname="demo_company",
        user="postgres",
        password="admin",
        host="localhost",
        port="5432"
    )

# Query execution with schema setup
def run_query(query):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SET search_path TO hr;")
    df = pd.read_sql_query(query, conn)
    conn.close()
    return df

# ----------------------
# SIDEBAR NAVIGATION
# ----------------------
with st.sidebar:
    selected = option_menu(
        menu_title="Main Menu",
        options=["Employee Overview", "Salary Insights", "Department View", "Attendance Analysis", "Download"],
        icons=["people", "currency-dollar", "building", "calendar-check", "cloud-download"],
        menu_icon="cast",
        default_index=0
    )

# ----------------------
# 1. EMPLOYEE OVERVIEW
# ----------------------
if selected == "Employee Overview":
    st.subheader("👥 Employee Snapshot")
    df_employees = run_query("""
        SELECT emp_id, first_name, last_name, gender, dob, hired_date, email, dept_id, job_id
        FROM employees
        ORDER BY hired_date DESC
        LIMIT 100
    """)
    st.dataframe(df_employees, use_container_width=True)

    st.metric("Total Employees", df_employees.shape[0])

# ----------------------
# 2. SALARY INSIGHTS
# ----------------------
elif selected == "Salary Insights":
    st.subheader("💰 Average Salary by Department")

    df_salary = run_query("""
        SELECT d.dept_name, ROUND(AVG(s.amount), 2) AS avg_salary
        FROM employees e
        JOIN salaries s ON e.emp_id = s.emp_id
        JOIN departments d ON e.dept_id = d.dept_id
        WHERE s.end_date IS NULL
        GROUP BY d.dept_name
        ORDER BY avg_salary DESC;
    """)

    fig, ax = plt.subplots(figsize=(10, 6))
    sns.barplot(data=df_salary, x="avg_salary", y="dept_name", ax=ax, palette="viridis")
    ax.set_xlabel("Average Salary")
    ax.set_ylabel("Department")
    st.pyplot(fig)

    highest_paid = df_salary.iloc[0]
    st.success(f"Highest Avg Salary: {highest_paid['dept_name']} (${highest_paid['avg_salary']})")

# ----------------------
# 3. DEPARTMENT VIEW
# ----------------------
elif selected == "Department View":
    st.subheader("🏢 Department-wise Employee Filter")
    departments = run_query("SELECT DISTINCT dept_name FROM departments ORDER BY dept_name")
    selected_dept = st.selectbox("Select Department", departments['dept_name'])

    df_filtered = run_query(f"""
        SELECT e.emp_id, e.first_name, e.last_name, d.dept_name, s.amount AS current_salary, e.hired_date
        FROM employees e
        JOIN departments d ON e.dept_id = d.dept_id
        JOIN salaries s ON e.emp_id = s.emp_id
        WHERE d.dept_name = '{selected_dept}' AND s.end_date IS NULL;
    """)

    st.write(f"### Employees in {selected_dept} Department")
    st.dataframe(df_filtered, use_container_width=True)

    st.metric("Count", df_filtered.shape[0])
    st.metric("Average Salary", f"${df_filtered['current_salary'].mean():.2f}")

# ----------------------
# 4. ATTENDANCE ANALYSIS
# ----------------------
elif selected == "Attendance Analysis":
    st.subheader("📅 Attendance Trends by Weekday")

    df_attendance = run_query("""
        SELECT EXTRACT(DOW FROM log_date) AS weekday, COUNT(*) AS logins
        FROM attendance
        GROUP BY weekday
        ORDER BY weekday;
    """)

    weekday_map = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    df_attendance['weekday'] = df_attendance['weekday'].astype(int)
    df_attendance['day'] = df_attendance['weekday'].map(lambda x: weekday_map[x])

    fig2, ax2 = plt.subplots(figsize=(8, 4))
    sns.barplot(data=df_attendance, x="day", y="logins", ax=ax2, palette="cubehelix")
    st.pyplot(fig2)

# ----------------------
# 5. DOWNLOAD SECTION
# ----------------------
elif selected == "Download":
    st.subheader("⬇️ Download Employees Data")

    df_all = run_query("""
        SELECT emp_id, first_name, last_name, gender, hired_date, email, phone, dept_id, job_id
        FROM employees ORDER BY emp_id
    """)

    st.dataframe(df_all, use_container_width=True)
    csv = df_all.to_csv(index=False)
    st.download_button("Download as CSV", csv, "employees_data.csv", "text/csv")

    st.success("Download Complete!")