//
//  PickersFile.swift
//  FinalProject
//
//  Created by Romano on 26/03/2018.
//  Copyright © 2018 Romano. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PickersFile{
    
    static let instance = PickersFile()
    private init(){
        
    }
    
    let jobsType = ["Account Executive",
                    "Account Manager",
                    "Account Representative",
                    "Accountant",
                    "Accounting Assistant",
                    "Accounting Clerk",
                    "Accounting Manager",
                    "Accounting Officer",
                    "Accounting Supervisor",
                    "Accounts Payable Clerk",
                    "Accounts Receivable Clerk",
                    "Administrative Assistant",
                    "Administrative Secretary",
                    "Administrative Services Manager",
                    "Administrative Supervisor",
                    "Advertising Agent",
                    "Aerospace Engineer",
                    "Applications Developer",
                    "Area Sales Managers",
                    "Assembler",
                    "Assistant Retail Manager",
                    "Assistant Store Manager",
                    "Attorney",
                    "Auditor",
                    "Auto Mechanic",
                    "Automotive Technician",
                    "Bank Manager",
                    "Bank Teller",
                    "Banking Center Manager",
                    "Barista",
                    "Benefits Manager",
                    "Benefits Specialist",
                    "Billing Clerk",
                    "Bookkeeper",
                    "Branch Manager",
                    "Brand Manager",
                    "Business Analyst",
                    "Business Development Manager",
                    "Business Manager",
                    "Business Systems Analyst",
                    "Buyer",
                    "Call Center Representative",
                    "Cashier",
                    "Catering Manager",
                    "CDL Driver",
                    "Certified Nursing Assistant",
                    "Certified Public Accountant",
                    "Charge Nurse",
                    "Chef",
                    "Chemical Technician",
                    "Chemist",
                    "Civil Engineer",
                    "Clerk",
                    "Client Services Representative",
                    "Clinic Nurse",
                    "Clinical Director",
                    "Communications Technician",
                    "Community Service Worker",
                    "Compliance Manager",
                    "Computer Architect",
                    "Computer Programmer",
                    "Computer Scientist",
                    "Computer Security Specialist",
                    "Computer Specialist",
                    "Computer Systems Engineer",
                    "Computer Technician",
                    "Construction Manager",
                    "Construction Worker",
                    "Controller",
                    "Corporate Recruiter",
                    "Cost Accountant",
                    "Credit Analyst",
                    "Crew Member",
                    "Critical Care Nurse",
                    "Customer Assistant",
                    "Customer Care Representative",
                    "Customer Service Agent",
                    "Customer Service Manager",
                    "Customer Service Representative",
                    "Customer Service Specialist",
                    "Customer Service Supervisor",
                    "Customer Service Technician",
                    "Data Entry Clerk",
                    "Database Administrator",
                    "Delivery Driver",
                    "Dental Assistant",
                    "Design Consultant",
                    "Director Of Nursing",
                    "Director Of Sales",
                    "Dishwasher",
                    "Dispatcher",
                    "Distribution Manager",
                    "District Sales Manager",
                    "Electrical Engineer",
                    "Electrician",
                    "Electronics Engineer",
                    "Engineering Manager",
                    "Environmental Engineer",
                    "Equipment Engineering Technician",
                    "Executive Assistant",
                    "Executive Chef",
                    "Facilities Manager",
                    "Field Technician",
                    "Financial Advisor",
                    "Financial Analyst",
                    "Financial Center Manager",
                    "Financial Reporting Accountant",
                    "Financial Services Representative",
                    "Food Service Director",
                    "Food Service Manager",
                    "Food Service Supervisor",
                    "Food Service Worker",
                    "Forklift Operator",
                    "General Accountant",
                    "General Manager",
                    "Graphic Designer",
                    "Health And Social Service Manager",
                    "Health Information Technician",
                    "Health Services Manager",
                    "Health Teacher",
                    "Health Technician",
                    "Healthcare Support Worker",
                    "Help Desk Analyst",
                    "Home Care Aide",
                    "Home Health Aide",
                    "Housekeeper",
                    "Human Resources Assistant",
                    "Human Resources Manager",
                    "Industrial Engineer",
                    "Industrial Mechanic",
                    "Industrial Production Manager",
                    "Industrial Safety Engineer",
                    "Information Systems Analyst",
                    "Information Systems Manager",
                    "Inside Sales Manager",
                    "Inspector",
                    "Insurance Agent",
                    "Insurance Sales Agent",
                    "Intelligence Analyst",
                    "IT Director",
                    "IT Specialist",
                    "Kitchen Manager",
                    "Lab Tech",
                    "Laborer",
                    "Legal Assistant",
                    "Legal Secretary",
                    "Licensed Nursing Assistant",
                    "Licensed Practical Nurse",
                    "Licensed Vocational Nurse",
                    "Loan Officer",
                    "Logistics Analyst",
                    "Machine Operator",
                    "Machinist",
                    "Maintenance Engineer",
                    "Maintenance Manager",
                    "Maintenance Supervisor",
                    "Maintenance Technician",
                    "Maintenance Worker",
                    "Management Analyst",
                    "Manufacturing Engineer",
                    "Manufacturing Supervisor",
                    "Market Research Analyst",
                    "Marketing Coordinator",
                    "Marketing Director",
                    "Marketing Manager",
                    "Material Handler",
                    "Mechanical Engineer",
                    "Medical Assistant",
                    "Medical Office Manager",
                    "Medical Records Manager",
                    "Medical Scientist",
                    "Medical Secretary",
                    "Medical Services Manager",
                    "Medical Technician",
                    "Member Services Representative",
                    "Mental Health Counselor",
                    "Network Administrator",
                    "Network Analyst",
                    "Network Engineer",
                    "Network Manager",
                    "Network Specialist",
                    "Nurse Practitioner",
                    "Nursing Aide",
                    "Nursing Assistant",
                    "Nursing Home Administrator",
                    "Occupational Therapist",
                    "Office Clerk",
                    "Office Coordinator",
                    "Office Manager",
                    "Office Nurse",
                    "Office Supervisor",
                    "Operations Manager",
                    "Order Clerk",
                    "Outside Sales Manager",
                    "Outside Sales Representative",
                    "Over The Road Driver",
                    "Package Delivery Driver",
                    "Package Handler",
                    "Patient Representative",
                    "Payroll Clerk",
                    "Petroleum Engineer",
                    "Pharmacist",
                    "Pharmacy Technician",
                    "Physical Therapist",
                    "Physical Therapist Assistant",
                    "Physician Assistant",
                    "Plant Engineer",
                    "Plant Manager",
                    "Practice Administrator",
                    "Prep Cook",
                    "Principal",
                    "Producer",
                    "Product Demonstrator",
                    "Production Assistant",
                    "Production Engineer",
                    "Production Manager",
                    "Production Supervisor",
                    "Production Worker",
                    "Professor",
                    "Property Manager",
                    "Public Health Nurse",
                    "Public Relations Manager",
                    "Public Relations Specialist",
                    "Purchasing Manager",
                    "Quality Assurance Engineer",
                    "Quality Control Analyst",
                    "Quality Control Systems Manager",
                    "Quality Engineer",
                    "Real Estate Agent",
                    "Receiving Clerk",
                    "Receptionist",
                    "Recruiter",
                    "Regional Sales Manager",
                    "Registered Nurse",
                    "Research Analyst",
                    "Restaurant Cook",
                    "Restaurant Manager",
                    "Retail Department Manager",
                    "Retail Manager",
                    "Retail Sales Associate",
                    "Retail Sales Manager",
                    "Retail Shift Manager",
                    "Retail Supervisor",
                    "Sales Associate",
                    "Sales Clerk",
                    "Sales Consultant",
                    "Sales Director",
                    "Sales Engineer",
                    "Sales Manager",
                    "Sales Representative",
                    "Sales Supervisor",
                    "Salesman",
                    "Salesperson",
                    "School Counselor",
                    "School Nurse",
                    "School Social Worker",
                    "Secretary",
                    "Security Agent",
                    "Security Guard",
                    "Security Officer",
                    "Service Technician",
                    "Social Services Manager",
                    "Social Worker",
                    "Software Architect",
                    "Software Developer",
                    "Software Development Engineer",
                    "Software Engineer",
                    "Staff Accountant",
                    "Staff Assistant",
                    "Staff Nurse",
                    "Staff Registered Nurse",
                    "Staff Services Manager",
                    "Stock Clerk",
                    "Store Manager",
                    "Supply Chain Engineer",
                    "Supply Chain Manager",
                    "System Engineer",
                    "Systems Administrator",
                    "Systems Analyst",
                    "Systems Engineer",
                    "Teacher",
                    "Teacher Assistant",
                    "Technical Recruiter",
                    "Technical Support Analyst",
                    "Technical Support Specialist",
                    "Technical Writer",
                    "Telecommunications Technician",
                    "Training Manager",
                    "Training Specialist",
                    "Transportation Manager",
                    "Truck Driver",
                    "Underwriter",
                    "Visual Merchandiser",
                    "Waiter",
                    "Warehouse Clerk",
                    "Warehouse Supervisor",
                    "Warehouse Worker",
                    "Web Designer",
                    "Web Developer",
                    "Welder"]
    
    let languages = ["Afrikaans",
                     "Albanian",
                     "Amharic",
                     "Arabic",
                     "Armenian",
                     "Azerbaijani",
                     "Basque",
                     "Belarusian",
                     "Bengali",
                     "Bosnian",
                     "Bulgarian",
                     "Burmese",
                     "Catalan",
                     "Cebuano",
                     "Chichewa",
                     "Chinese",
                     "Corsican",
                     "Croatian",
                     "Czech",
                     "Danish",
                     "Dutch",
                     "English",
                     "Esperanto",
                     "Estonian",
                     "Filipino",
                     "Finnish",
                     "French",
                     "Frisian",
                     "Galician",
                     "Georgian",
                     "German",
                     "Greek",
                     "Gujarati",
                     "Haitian Creole",
                     "Hausa",
                     "Hawaiian",
                     "Hebrew",
                     "Hindi",
                     "Hmong",
                     "Hungarian",
                     "Icelandic",
                     "Igbo",
                     "Indonesian",
                     "Irish",
                     "Italian",
                     "Japanese",
                     "Javanese",
                     "Kannada",
                     "Kazakh",
                     "Khmer",
                     "Korean",
                     "Kurdish(Kurmanji)",
                     "Kyrgyz",
                     "Lao",
                     "Latin",
                     "Latvian",
                     "Lithuanian",
                     "Luxembourgish",
                     "Macedonian",
                     "Malagasy",
                     "Malay",
                     "Malayalam",
                     "Maltese",
                     "Maori",
                     "Marathi",
                     "Mongolian",
                     "Nepali",
                     "Norwegian(Bokmål)",
                     "Pashto",
                     "Persian",
                     "Polish",
                     "Portuguese",
                     "Punjabi",
                     "Romanian",
                     "Russian",
                     "Samoan",
                     "Scots Gaelic",
                     "Serbian",
                     "Sesotho",
                     "Shona",
                     "Sindhi",
                     "Sinhala",
                     "Slovak",
                     "Slovenian",
                     "Somali",
                     "Spanish",
                     "Sundanese",
                     "Swahili",
                     "Swedish",
                     "Tajik",
                     "Tamil",
                     "Telugu",
                     "Thai",
                     "Turkish",
                     "Ukrainian",
                     "Urdu",
                     "Uzbek",
                     "Vietnamese",
                     "Welsh",
                     "Xhosa",
                     "Yiddish",
                     "Yoruba",
                     "Zulu"]
    
    
    let countryNames = ["Afghanistan",
                        "Albania",
                        "Algeria",
                        "Andorra",
                        "Angola",
                        "Anguilla",
                        "Antigua & Barbuda",
                        "Argentina",
                        "Armenia",
                        "Australia",
                        "Austria",
                        "Azerbaijan",
                        "Bahamas",
                        "Bahrain",
                        "Bangladesh",
                        "Barbados",
                        "Belarus",
                        "Belgium",
                        "Belize",
                        "Benin",
                        "Bermuda",
                        "Bhutan",
                        "Bolivia",
                        "Bosnia & Herzegovina",
                        "Botswana",
                        "Brazil",
                        "Brunei Darussalam",
                        "Bulgaria",
                        "Burkina Faso",
                        "Myanmar/Burma",
                        "Burundi",
                        "Cambodia",
                        "Cameroon",
                        "Canada",
                        "Cape Verde",
                        "Cayman Islands",
                        "Central African Republic",
                        "Chad",
                        "Chile",
                        "China",
                        "Colombia",
                        "Comoros",
                        "Congo",
                        "Costa Rica",
                        "Croatia",
                        "Cuba",
                        "Cyprus",
                        "Czech Republic",
                        "Democratic Republic of the Congo",
                        "Denmark",
                        "Djibouti",
                        "Dominica",
                        "Dominican Republic",
                        "Ecuador",
                        "Egypt",
                        "El Salvador",
                        "Equatorial Guinea",
                        "Eritrea",
                        "Estonia",
                        "Ethiopia",
                        "Fiji",
                        "Finland",
                        "France",
                        "French Guiana",
                        "Gabon",
                        "Gambia",
                        "Georgia",
                        "Germany",
                        "Ghana",
                        "Great Britain",
                        "Greece",
                        "Grenada",
                        "Guadeloupe",
                        "Guatemala",
                        "Guinea",
                        "Guinea-Bissau",
                        "Guyana",
                        "Haiti",
                        "Honduras",
                        "Hungary",
                        "Iceland",
                        "India",
                        "Indonesia",
                        "Iran",
                        "Iraq",
                        "Israel",
                        "Italy",
                        "Ivory Coast (Cote d'Ivoire)",
                        "Jamaica",
                        "Japan",
                        "Jordan",
                        "Kazakhstan",
                        "Kenya",
                        "Kosovo",
                        "Kuwait",
                        "Kyrgyz Republic (Kyrgyzstan)",
                        "Laos",
                        "Latvia",
                        "Lebanon",
                        "Lesotho",
                        "Liberia",
                        "Libya",
                        "Liechtenstein",
                        "Lithuania",
                        "Luxembourg",
                        "Republic of Macedonia",
                        "Madagascar",
                        "Malawi",
                        "Malaysia",
                        "Maldives",
                        "Mali",
                        "Malta",
                        "Martinique",
                        "Mauritania",
                        "Mauritius",
                        "Mayotte",
                        "Mexico",
                        "Moldova, Republic of",
                        "Monaco",
                        "Mongolia",
                        "Montenegro",
                        "Montserrat",
                        "Morocco",
                        "Mozambique",
                        "Namibia",
                        "Nepal",
                        "Netherlands",
                        "New Zealand",
                        "Nicaragua",
                        "Niger",
                        "Nigeria",
                        "Korea, Democratic Republic of (North Korea)",
                        "Norway",
                        "Oman",
                        "Pacific Islands",
                        "Pakistan",
                        "Panama",
                        "Papua New Guinea",
                        "Paraguay",
                        "Peru",
                        "Philippines",
                        "Poland",
                        "Portugal",
                        "Puerto Rico",
                        "Qatar",
                        "Reunion",
                        "Romania",
                        "Russian Federation",
                        "Rwanda",
                        "Saint Kitts and Nevis",
                        "Saint Lucia",
                        "Saint Vincent's & Grenadines",
                        "Samoa",
                        "Sao Tome and Principe",
                        "Saudi Arabia",
                        "Senegal",
                        "Serbia",
                        "Seychelles",
                        "Sierra Leone",
                        "Singapore",
                        "Slovak Republic (Slovakia)",
                        "Slovenia",
                        "Solomon Islands",
                        "Somalia",
                        "South Africa",
                        "Korea, Republic of (South Korea)",
                        "South Sudan",
                        "Spain",
                        "Sri Lanka",
                        "Sudan",
                        "Suriname",
                        "Swaziland",
                        "Sweden",
                        "Switzerland",
                        "Syria",
                        "Tajikistan",
                        "Tanzania",
                        "Thailand",
                        "Timor Leste",
                        "Togo",
                        "Trinidad & Tobago",
                        "Tunisia",
                        "Turkey",
                        "Turkmenistan",
                        "Turks & Caicos Islands",
                        "Uganda",
                        "Ukraine",
                        "United Arab Emirates",
                        "United States of America (USA)",
                        "Uruguay",
                        "Uzbekistan",
                        "Venezuela",
                        "Vietnam",
                        "Virgin Islands (UK)",
                        "Virgin Islands (US)",
                        "Yemen",
                        "Zambia",
                        "Zimbabwe"]
    
    let salary = ["5000-10,000",
                  "10,000-15,000",
                  "15,000-20,000",
                  "20,000-25,000",
                  "25,000-30,000",
                  "30,000-35,000",
                  "35,000-40,000",
                  "40,000-45,000",
                  "45,000-50,000",
                  "50,000-60,000",
                  "60,000-70,000",
                  "70,000-80,000",
                  "80,000-90,000",
                  "90,000-100,000"]
    
    let yesNo = ["Yes","No"]
    
    let workExperience = ["0","1",
                          "2",
                          "3",
                          "4",
                          "5",
                          "6",
                          "7",
                          "8",
                          "9",
                          "10",
                          "11",
                          "12",
                          "13",
                          "14",
                          "15",
                          "16",
                          "17",
                          "18",
                          "19",
                          "20",
                          "21",
                          "22",
                          "23",
                          "24",
                          "25",
                          "26",
                          "27",
                          "28",
                          "29",
                          "30",
                          "31",
                          "32",
                          "33",
                          "34",
                          "35",
                          "36",
                          "37",
                          "38",
                          "39",
                          "40",
                          "41",
                          "42",
                          "43",
                          "44",
                          "45",
                          "46",
                          "47",
                          "48",
                          "49",
                          "50"]
    
    let workHours = ["0","1",
                          "2",
                          "3",
                          "4",
                          "5",
                          "6",
                          "7",
                          "8",
                          "9"]
    
    let education = ["High school Education ",
                     "Engineer",
                     "Technician",
                     "BA",
                     "Master's degree",
                     "Doctor",
                     "Professor",
                     "Diploma",
                     "Teaching studies",
                     "Torah studies"]
    
    let age = ["1",
               "2",
               "3",
               "4",
               "5",
               "6",
               "7",
               "8",
               "9",
               "10",
               "11",
               "12",
               "13",
               "14",
               "15",
               "16",
               "17",
               "18",
               "19",
               "20",
               "21",
               "22",
               "23",
               "24",
               "25",
               "26",
               "27",
               "28",
               "29",
               "30",
               "31",
               "32",
               "33",
               "34",
               "35",
               "36",
               "37",
               "38",
               "39",
               "40",
               "41",
               "42",
               "43",
               "44",
               "45",
               "46",
               "47",
               "48",
               "49",
               "50",
               "51",
               "52",
               "53",
               "54",
               "55",
               "56",
               "57",
               "58",
               "59",
               "60",
               "61",
               "62",
               "63",
               "64",
               "65",
               "66",
               "67"]
    
    let gender = ["Male", "Female"]
    
    func jobTypes()->[String]
    {
        return self.jobsType
    }
    
    func getCountryNames()->[String]
    {
        return self.countryNames
    }

    func getLanguages()->[String]
    {
        return self.languages
    }
    
    func getSalary()->[String]
    {
        return self.salary
    }

    func getYesNo()->[String]
    {
        return self.yesNo
    }
    
    func getWorkExperience()->[String]
    {
        return self.workExperience
    }
    
    func getWorkHours()->[String]
    {
        return self.workHours
    }
    
    func getEducation()->[String]
    {
        return self.education
    }

    
    func getAges()->[String]
    {
        return self.age
    }
    
    func getGender()->[String]
    {
        return self.gender
    }
    
}
