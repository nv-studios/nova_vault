# 🌌 Nova_Vault

Nova_Vault is an open-source, highly secure terminal-based credential manager and password vault. Built natively for **Windows Batch (.bat)** and **Linux Bash (.sh)**, it provides an isolated local storage matrix to securely encrypt, store, and look up sensitive digital assets—including **SSH Keys, API Tokens, Master Passwords, Verification Codes, and Emails**.

---

## ✨ Features

- **🔐 Cryptographic Master Lock:** Restricts entry via a user-defined master password. Access and decryption algorithms remain strictly frozen until authorization tokens are verified.
- **🛡️ Obfuscated Local Storage Engine:** Saved assets do not sit in plain text. All records run through a symmetric cryptographic transposition matrix before hitting the flat-file database (`vault_data.db`), rendering them unreadable to text editors or file browsers.
- **🏷️ Structured Asset Management:** Categorizes credentials cleanly by Label, Username/Email, and Secret values.
- **🎯 Dynamic Interface Models:** 
  - **Windows (`nova_vault.bat`):** Features a sleek slate-gray layout with a responsive, color-blocked **Cyan Highlight Selector Bar** controlled by arrow keys.
  - **Linux (`nova_vault.sh`):** Fully optimized console utility using standard input loops, cleanly colorized and visible against dark terminal backgrounds.

---

## 🚀 Quick Start Installation Guide

### Option A: Windows Engine (`nova_vault.bat`)
1. Download `nova_vault.bat` into an isolated, private folder on your machine.
2. Double-click the file to launch the terminal application.
3. On first boot, follow the prompt to create your unique **Master Password**. *(Warning: If you lose this password, your database cannot be decrypted).*
4. Navigate menus cleanly using your keyboard's **Up/Down Arrow Keys** and press **Enter** to select options.

### Option B: Linux Engine (`nova_vault.sh`)
1. Download `nova_vault.sh` into your workspace (e.g., your ThinkPad's Downloads folder).
2. Open a standard terminal console window and apply the required script execution flags:
   ```bash
   chmod +x nova_vault.sh
   ```
3. Boot the native shell interface utility:
   ```bash
   ./nova_vault.sh
   ```
4. Set up your master security key framework and navigate using terminal number menus (`1-4`).

---

## 📂 File Structure Details
Once initialized, the application manages data across two simple files generated in the root execution directory:
- `vault_master.ini` - Holds the master account validation profile parameters.
- `vault_data.db` - Stores your securely cipher-scrambled data logs.

---

## ⚖️ License & Attribution
Distributed under the MIT Open Source License. 

Made with ❤️ by **Nova Studios**. Feel free to fork this project, submit issue reports, or optimize the cryptographic algorithm matrix!
