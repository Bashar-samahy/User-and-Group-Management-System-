# Bash User & Group Manager  

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)  
*A lightweight, interactive user/group management tool for Linux.*  

---

## 🚀 Features  
- **User Management**: Add, modify, delete, lock/unlock users.  
- **Group Management**: Create, modify, delete groups.  
- **Password Control**: Change user passwords securely.  
- **Whiptail UI**: Interactive terminal menus for ease of use.  
- **Root Protection**: Auto-checks for `sudo`/root privileges.  

---

## 🛠️ Technologies Used  
- **Bash Scripting**  
- **Whiptail** (for dialog boxes)  
- Core Linux tools: `useradd`, `usermod`, `groupadd`, `passwd`, `awk`.  

---

## 📦 Installation & Usage  

1. Clone the repository

`git clone https://github.com/Bashar-samahy/User-and-Group-Management-System-.git`  

`cd User-and-Group-Management-System-`  

2. Make the script executable
`chmod +x Project.sh`

3. Run the script (as root)

`sudo ./project.sh`

---

## 🖥️ Demo (Screenshots)

### Main Menu

<img width="951" height="731" alt="image" src="https://github.com/user-attachments/assets/c6e5c621-0e8b-4003-afd0-ce9ff99a9ae5" />


### Adding a User

<img width="506" height="261" alt="image" src="https://github.com/user-attachments/assets/a3908111-8350-4710-a36a-1be8341398a3" />




---


## 📝 Notes
Requires root access (`sudo`).

Tested `CentOS`, `RedHat`, `Rockey`.

---

### **2. Organize Repository Structure**

bash-user-group-manager/

├── README.md # Project documentation (main page)

├── menu_project.sh # Main Bash script

├── demo/ # Screenshots/GIFs for demo

│ ├── main_menu.png

│ └── add_user.png

└── LICENSE # Add a license (e.g., MIT)

---

### **3. Enhance Visibility with GitHub Features**
- **Badges**: Add shields.io badges (e.g., Bash version, license) to `README.md`.  
- **Screenshots**: Include Whiptail UI screenshots in the `demo/` folder.  
- **Tags/Labels**: Use GitHub topics like `bash`, `linux`, `sysadmin`.  

---

### **4. Optional but Helpful Additions**
- **Wiki**: Add a wiki for advanced usage (e.g., customizing Whiptail).  
- **Issues Template**: Guide users on how to report bugs.  

### **5. Push Changes to GitHub**
`git add README.md demo/ Project.sh`
`git commit -m "Updated README to match reference project"`
`git push origin mai`
n

---


Let me know if you’d like help with specific GitHub markdown syntax or automation! 🚀
