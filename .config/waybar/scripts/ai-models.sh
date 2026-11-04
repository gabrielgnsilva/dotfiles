#!/usr/bin/env sh

API_URL="http://127.0.0.1:8080/v1/models"
ROUTER_URL="http://127.0.0.1:8080"
ICON="󰧑"

get_loaded_model() {
  curl -fsS --connect-timeout 1 --max-time 2 "${API_URL}" 2>/dev/null \
    | jq -r '[.data[]? | select(.status.value == "loaded")][0].id // empty'
}

get_model_status() {
  curl -fsS --connect-timeout 1 --max-time 2 "${API_URL}" 2>/dev/null \
    | jq -r --arg model "${1}" \
      '.data[]? | select(.id == $model) | .status.value'
}

unload_model() {
  model=$(get_loaded_model)

  [ -n "${model}" ] || exit 0

  payload=$(jq -n --arg model "${model}" '{model: $model}')
  if curl -fsS --connect-timeout 1 --max-time 5 \
    -X POST "${ROUTER_URL}/models/unload" \
    -H 'Content-Type: application/json' \
    -d "${payload}" >/dev/null; then
    notify-send --app-name "Waybar" --urgency normal \
      "AI Model" "Model unloaded: ${model}"
  else
    notify-send --app-name "Waybar" --urgency critical \
      "AI Model" "Failed to unload model: ${model}"
  fi
}

load_model() {
  model="${1}"
  payload=$(jq -n --arg model "${model}" '{model: $model}')

  if curl -fsS --connect-timeout 1 --max-time 5 \
    -X POST "${ROUTER_URL}/models/load" \
    -H 'Content-Type: application/json' \
    -d "${payload}" >/dev/null; then
    notify-send --app-name "Waybar" --urgency normal \
      "AI Model" "Loading model: ${model}"

    attempt=0
    while [ "${attempt}" -lt 60 ]; do
      status=$(get_model_status "${model}")
      case "${status}" in
        loaded)
          notify-send --app-name "Waybar" --urgency normal \
            "AI Model" "Model loaded: ${model}"
          return 0
          ;;
        unloaded|error)
          notify-send --app-name "Waybar" --urgency critical \
            "AI Model" "Failed to load model: ${model}"
          return 1
          ;;
      esac
      attempt=$((attempt + 1))
      sleep 1
    done

    notify-send --app-name "Waybar" --urgency critical \
      "AI Model" "Timed out loading model: ${model}"
    return 1
  else
    notify-send --app-name "Waybar" --urgency critical \
      "AI Model" "Failed to load model: ${model}"
  fi
}

show_menu() {
  loaded_model=$(get_loaded_model)
  menu_message="Loaded model: ${loaded_model:-none}"
  action=$(printf '%s\n' '* Unload model' '> List models' \
    | rofi -dmenu -i -mesg "${menu_message}" -theme-str '@import "list-select"')

  case "${action}" in
    '* Unload model') unload_model ;;
    '> List models') list_models ;;
  esac
}

list_models() {
  models=$(curl -fsS --connect-timeout 1 --max-time 2 "${API_URL}" 2>/dev/null \
    | jq -r '.data[]? | select(.status.value == "unloaded") | .id')

  [ -n "${models}" ] || models="No models available"

  selected_model=$(printf '%s\n' "${models}" \
    | rofi -dmenu -i -mesg 'Available models to load:' \
      -theme-str '@import "list-select"')

  case "${selected_model}" in
    ''|'No models available') return 0 ;;
    *) load_model "${selected_model}" ;;
  esac
}

notify_model() {
  loaded_model=$(get_loaded_model)
  if [ -n "${loaded_model}" ]; then
    message="Loaded model: ${loaded_model}"
  else
    message="No model loaded"
  fi
  notify-send --app-name "Waybar" --urgency normal \
    "AI Model" "${message}"
}

if [ "${1:-}" = "--menu" ]; then
  show_menu
  exit $?
fi

if [ "${1:-}" = "--notify" ]; then
  notify_model
  exit $?
fi

if [ "${1:-}" = "--unload" ]; then
  unload_model
  exit $?
fi

loaded_model=$(get_loaded_model)

if [ -n "${loaded_model}" ]; then
  jq -cn \
    --arg text " ${ICON} (${loaded_model})" \
    --arg tooltip "AI model loaded: ${loaded_model}" \
    '{text: $text, tooltip: $tooltip, class: "loaded"}'
fi
