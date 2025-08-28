#!/bin/bash

CONFIG_FILE="config.yml"
ITEM_TITLE="macos-config"
VAULT="Personal"

show_help() {
    echo "Usage: $0 [store|retrieve|help]"
    echo ""
    echo "Commands:"
    echo "  store     - Upload config.yml to 1Password"
    echo "  retrieve  - Download config.yml from 1Password"
    echo "  help      - Show this help message"
}

store_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: $CONFIG_FILE not found in current directory"
        exit 1
    fi
    
    echo "Storing $CONFIG_FILE to 1Password..."
    
    if op document get "$ITEM_TITLE" --vault "$VAULT" &>/dev/null; then
        echo "Item exists, deleting old version..."
        op item delete "$ITEM_TITLE" --vault "$VAULT" --archive
        if [ $? -ne 0 ]; then
            echo "Warning: Could not delete old item, proceeding anyway..."
        fi
    fi
    
    echo "Creating document in 1Password..."
    op document create "$CONFIG_FILE" --title="$ITEM_TITLE" --vault="$VAULT"
    if [ $? -eq 0 ]; then
        echo "✓ Successfully stored $CONFIG_FILE in 1Password"
    else
        echo "✗ Failed to store $CONFIG_FILE in 1Password"
        exit 1
    fi
}

retrieve_config() {
    echo "Retrieving $CONFIG_FILE from 1Password..."
    
    if [ -f "$CONFIG_FILE" ]; then
        read -p "$CONFIG_FILE already exists. Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted"
            exit 0
        fi
    fi
    
    op document get "$ITEM_TITLE" --vault "$VAULT" --output "$CONFIG_FILE"
    if [ $? -eq 0 ]; then
        echo "✓ Successfully retrieved $CONFIG_FILE from 1Password"
    else
        echo "✗ Failed to retrieve $CONFIG_FILE from 1Password"
        exit 1
    fi
}

if ! command -v op &> /dev/null; then
    echo "Error: 1Password CLI (op) is not installed"
    echo "Install it from: https://developer.1password.com/docs/cli/get-started/"
    exit 1
fi

if ! op whoami &> /dev/null; then
    echo "Not signed in to 1Password. Signing in..."
    eval $(op signin)
fi

case "$1" in
    store)
        store_config
        ;;
    retrieve)
        retrieve_config
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac