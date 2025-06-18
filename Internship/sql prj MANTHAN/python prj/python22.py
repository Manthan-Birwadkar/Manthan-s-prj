import requests
from bs4 import BeautifulSoup
import pandas as pd 

base_url = "https://www.timesjobs.com/candidate/job-search.html?searchType=Home_Search&from=submit&asKey=OFF&txtKeywords=&cboPresFuncArea=28"
results_per_page = 24
total_results_to_fetch = 9000

lst = []

for page in range(1, (total_results_to_fetch // results_per_page) + 2):
    params = {
        'searchType': 'Home_Search',
        'from': 'submit',
        'asKey': 'OFF',
        'txtKeywords': 'IT',  
        'cboPresFuncArea': '',  
        'perPage': results_per_page,
        'pageNo': page
    }

    res = requests.get(base_url, params=params)
    soup = BeautifulSoup(res.content, 'html.parser')

    pg1_div = soup.find_all('li', class_='clearfix job-bx wht-shd-bx')

    for job in pg1_div:
        Job_title = job.find('h2').text.strip()
        Company_Name = job.find('h3', class_='joblist-comp-name').text.strip()

        
        experience_element = job.find('i', class_="material-icons")
        Experience = experience_element.next_sibling.strip() if experience_element else None

        
        package_element = job.find('i', class_='material-icons rupee')
        Package = package_element.next_sibling.strip() if package_element else None

        Location = job.find('ul', class_='top-jd-dtl clearfix').find_all('li')[1].text.strip()
        Description = job.find('ul', class_='list-job-dtl clearfix').find('li').text.strip()
        key_skills = job.find('span', class_='srp-skills').text.strip()

        job_dic = {
            "Job Title": Job_title,
            "Company Name": Company_Name,
            "Exp": Experience,
            "Package": Package,
            "Location": Location,
            "Job Description": Description,
            "Key Skills": key_skills
        }

        lst.append(job_dic)

    
    if len(lst) >= total_results_to_fetch:
        break

jobs_df = pd.DataFrame(lst[:total_results_to_fetch]) 
jobs_df.to_excel('data scraping for jobdata link 2.xlsx', index=False)