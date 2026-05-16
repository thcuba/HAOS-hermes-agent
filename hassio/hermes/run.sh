#!/usr/bin/with-contenv bashio

# Home Assistant Add-on entrypoint for Hermes Agent

HERMES_HOME="/data"
export HERMES_HOME

bashio::log.info "Starting Hermes Agent Add-on..."

# Map add-on options to environment variables
export OPENROUTER_API_KEY=$(bashio::config 'openrouter_api_key')
export OPENAI_API_KEY=$(bashio::config 'openai_api_key')
export ANTHROPIC_API_KEY=$(bashio::config 'anthropic_api_key')
export HERMES_DASHBOARD=$(bashio::config 'enable_dashboard')
export HERMES_GATEWAY_BUSY_INPUT_MODE=$(bashio::config 'busy_input_mode')

# Home Assistant integration
export HASS_URL="http://supervisor/core"
export HASS_TOKEN="${SUPERVISOR_TOKEN}"

bashio::log.info "Home Assistant API integration enabled."

# Bootstrap essential files if they don't exist in /data
INSTALL_DIR="/opt/hermes"

mkdir -p "$HERMES_HOME"/{cron,sessions,logs,hooks,memories,skills,skins,plans,workspace,home}

if [ ! -f "$HERMES_HOME/.env" ]; then
    bashio::log.info "Bootstrapping .env"
    cp "$INSTALL_DIR/.env.example" "$HERMES_HOME/.env"
fi

if [ ! -f "$HERMES_HOME/config.yaml" ]; then
    bashio::log.info "Bootstrapping config.yaml"
    cp "$INSTALL_DIR/cli-config.yaml.example" "$HERMES_HOME/config.yaml"
fi

if [ ! -f "$HERMES_HOME/SOUL.md" ]; then
    cp "$INSTALL_DIR/docker/SOUL.md" "$HERMES_HOME/SOUL.md"
fi

# Sync skills
python3 "$INSTALL_DIR/tools/skills_sync.py"

# Start the gateway
bashio::log.info "Launching Hermes Gateway..."
exec hermes gateway
