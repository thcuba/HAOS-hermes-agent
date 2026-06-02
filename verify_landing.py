from jinja2 import Template
import json

with open("landing.html.tpl") as f:
    template_content = f.read()

# Mock values
hermes_version = "0.15.1"
addon_slug = "hermes"
show_terminal = "true"
show_dashboard = "true"
show_dashboard_ports = "false"
show_api = "true"
profiles_json = json.dumps([{"name": "default", "prefix": "", "primary": True}])

# Simple replacement instead of full jinja if it is just sed
content = template_content.replace("%%HERMES_VERSION%%", hermes_version)
content = content.replace("%%ADDON_SLUG%%", addon_slug)
content = content.replace("%%SHOW_TERMINAL%%", show_terminal)
content = content.replace("%%SHOW_DASHBOARD%%", show_dashboard)
content = content.replace("%%SHOW_DASHBOARD_PORTS%%", show_dashboard_ports)
content = content.replace("%%SHOW_API%%", show_api)
content = content.replace("%%PROFILES_JSON%%", profiles_json)

with open("landing_rendered.html", "w") as f:
    f.write(content)

print("Rendered landing page to landing_rendered.html")
