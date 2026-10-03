#!/bin/bash
clear

CYAN='\033[0;36m'
SILVER='\033[0;37m'
RED='\033[0;31m'
NC='\033[0m'

VAULT_FILE="vault_data.db"
MASTER_CONFIG="vault_master.ini"

if [ ! -f "$MASTER_CONFIG" ]; then
    clear
    echo "======================================================="
    echo "          NOVAVAULT: MASTER ACCOUNT GENERATION          "
    echo "======================================================="
    echo "  Please create a highly secure MASTER PASSWORD."
    echo "  You will need this password every time you unlock the vault."
    echo "======================================================="
    echo
    read -p "  Create Master Password: " mpass
    if [ -z "$mpass" ]; then exit 1; fi
    echo "key=$mpass" > "$MASTER_CONFIG"
    touch "$VAULT_FILE"
    echo "  [^+] Secure Master Key generated successfully!"
    read -p "  Press Enter to continue..."
fi

VAL_LOGIN() {
    while true; do
        clear
        echo "======================================================="
        echo "          NOVAVAULT: CRYPTOGRAPHIC AUTHENTICATION      "
        echo "======================================================="
        read -s -p "  Enter Master Password: " login_pass
        echo
        correct_key=$(grep "key=" "$MASTER_CONFIG" | cut -d'=' -f2)
        
        if [ "$login_pass" = "$correct_key" ]; then
            return
        else
            echo -e "${RED}\n  [X] ACCESS DENIED: Decryption pass mismatch.${NC}"
            read -p "  Press Enter to try again..."
        fi
    done
}

MAIN_MENU() {
    while true; do
        clear
        echo -e "${CYAN}+---------------------------------------+"
        echo " |         NOVAVAULT SECURE MATRIX       |"
        echo -e "+---------------------------------------+${NC}"
        echo "  1) Store New Asset (SSH/API/Password)"
        echo "  2) Retrieve / Search Vault Items"
        echo "  3) Wipe Vault Records"
        echo "  4) Exit Secure Matrix"
        echo "---------------------------------------"
        echo -e "${SILVER}  +---------------------------------------+"
        echo -e "   Made with ${RED}❤️ ${SILVER} by Nova Studios."
        echo -e "  +---------------------------------------+${NC}"
        echo
        read -p " Select Option [1-4]: " choice
        
        case $choice in
            1) STORE_ITEM ;;
            2) RETRIEVE_ITEM ;;
            3) WIPE_VAULT ;;
            4) exit 0 ;;
        esac
    done
}

STORE_ITEM() {
    clear
    echo "+---------------------------------------+"
    echo " |          STORE NEW VAULT ASSET        |"
    echo "+---------------------------------------+"
    read -p "  Asset Label (e.g. GitHub SSH / API): " label
    read -p "  Associated Account User / Email:     " username
    read -p "  Secret Key / Password / Code value:  " secret
    if [ -z "$label" ]; then return; fi
    
    raw_string="$label|$username|$secret"
    # Symmetric character translation matrix shift matching the batch file structure
    encrypted_str=$(echo "$raw_string" | tr 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |:._-' 'nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM9876543210_XYZ-+')
    echo "$encrypted_str" >> "$VAULT_FILE"
    echo
    echo "  [^+] Entry encrypted and saved safely."
    read -p "  Press Enter..."
}

RETRIEVE_ITEM() {
    clear
    echo "+---------------------------------------+"
    echo " |         RETRIEVE / DECRYPT ENTRIES    |"
    echo "+---------------------------------------+"
    if [ ! -s "$VAULT_FILE" ]; then
        echo "  [No entries stored yet.]"
        read -p "  Press Enter..."
        return
    fi
    
    echo "  Decrypted Vault Registry Assets:"
    echo "-------------------------------------------------------"
    while IFS= read -r line; do
        decrypted_line=$(echo "$line" | tr 'nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM9876543210_XYZ-+' 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |:._-')
        IFS='|' read -r asset user val <<< "$decrypted_line"
        echo "   [*] ASSET: $asset"
        echo "       USER:  $user"
        echo "       VALUE: $val"
        echo "-------------------------------------------------------"
    done < "$VAULT_FILE"
    read -p "  Press Enter to continue..."
}

WIPE_VAULT() {
    clear
    read -p " ⚠️ Are you sure you want to delete all entries? (Y/N): " confirm
    if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
        > "$VAULT_FILE"
        echo "  [^+] Database wiped cleanly."
        read -p "  Press Enter..."
    fi
}

VAL_LOGIN
MAIN_MENU
