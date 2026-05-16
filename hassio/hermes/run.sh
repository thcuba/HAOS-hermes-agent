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

# Apply dashboard compatibility patches if needed
if [ "$HERMES_DASHBOARD" = "true" ]; then
    PATCH_STATUS_FILE="$(mktemp)"
    if ! python3 "$INSTALL_DIR/hassio/hermes/dashboard-patches.py" "$INSTALL_DIR" "$PATCH_STATUS_FILE"; then
        bashio::log.warn "Dashboard compatibility patch failed - continuing startup"
    fi

    # Check for legacy build marker and existing dist
    DASHBOARD_REBUILD="false"
    if [ -s "$PATCH_STATUS_FILE" ]; then
        DASHBOARD_REBUILD="true"
    fi
    if [ ! -d "$INSTALL_DIR/hermes_cli/web_dist/assets" ]; then
         DASHBOARD_REBUILD="true"
    fi

    if [ "$DASHBOARD_REBUILD" = "true" ]; then
        bashio::log.info "Dashboard assets missing or patched; rebuilding..."
        (cd "$INSTALL_DIR/web" && npm run build)
    fi
    rm -f "$PATCH_STATUS_FILE"

    # Start the dashboard in the background
    bashio::log.info "Launching Hermes Dashboard..."
    hermes dashboard --port 9119 --host 127.0.0.1 --no-open --skip-build &
    DASHBOARD_PID=$!

    # Wait for dashboard to start and obtain its session token
    DASHBOARD_TOKEN=""
    bashio::log.info "Waiting for dashboard token..."
    for i in $(seq 1 15); do
        DASHBOARD_TOKEN=$(curl -s "http://127.0.0.1:9119/" 2>/dev/null | grep -oP '__HERMES_SESSION_TOKEN__="\K[^"]+' || true)
        if [ -n "$DASHBOARD_TOKEN" ]; then
            break
        fi
        sleep 2
    done

    if [ -z "$DASHBOARD_TOKEN" ]; then
        bashio::log.warn "Could not read dashboard token (Ingress auth may fail)"
        DASHBOARD_TOKEN="UNAVAILABLE"
    fi
    bashio::log.info "Dashboard token obtained (${#DASHBOARD_TOKEN} chars)"
fi

# Start Nginx if Ingress is enabled
if bashio::config.has_value 'ingress_port'; then
    INGRESS_PORT=$(bashio::config 'ingress_port')
    bashio::log.info "Configuring Nginx for Ingress on port $INGRESS_PORT"

    cp "$INSTALL_DIR/hassio/hermes/nginx.conf.tpl" /etc/nginx/nginx.conf
    sed -i "s/%%INGRESS_PORT%%/$INGRESS_PORT/g" /etc/nginx/nginx.conf
    sed -i "s/%%DASHBOARD_TOKEN%%/$DASHBOARD_TOKEN/g" /etc/nginx/nginx.conf

    mkdir -p /run/nginx
    nginx
fi

# Start the gateway
bashio::log.info "Launching Hermes Gateway..."
exec hermes gateway
