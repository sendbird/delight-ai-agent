#!/bin/bash
# Generate label sections for create-discussion.yml
# This script is separate from YAML to avoid GitHub Actions parser issues with ${{

LABELS_FILE="/tmp/labels.txt"

# Generate LABEL_INPUTS section
echo "      # --- LABEL_INPUTS_START ---" > /tmp/label_inputs.txt
while IFS= read -r label; do
  [ -z "$label" ] && continue

  # Skip non-customization labels (bug, documentation, etc.)
  if ! echo "$label" | grep -q "^🎨"; then
    continue
  fi

  # Create variable name: remove leading emoji/special chars, lowercase, spaces to dashes
  var_name=$(echo "$label" | sed 's/^[^a-zA-Z]*//' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
  [ -z "$var_name" ] && continue

  echo "      label-${var_name}:" >> /tmp/label_inputs.txt
  echo "        description: '${label}'" >> /tmp/label_inputs.txt
  echo "        type: boolean" >> /tmp/label_inputs.txt
  echo "        default: false" >> /tmp/label_inputs.txt
done < "$LABELS_FILE"
echo "      # --- LABEL_INPUTS_END ---" >> /tmp/label_inputs.txt

# Generate LABEL_ENV section
echo "      # --- LABEL_ENV_START ---" > /tmp/label_env.txt
while IFS= read -r label; do
  [ -z "$label" ] && continue

  # Skip non-customization labels
  if ! echo "$label" | grep -q "^🎨"; then
    continue
  fi

  var_name=$(echo "$label" | sed 's/^[^a-zA-Z]*//' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
  [ -z "$var_name" ] && continue

  # Convert to uppercase for env var
  env_var_name=$(echo "$var_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
  echo "      INPUT_LABEL_${env_var_name}: \${{ github.event.inputs.label-${var_name} }}" >> /tmp/label_env.txt
done < "$LABELS_FILE"
echo "      # --- LABEL_ENV_END ---" >> /tmp/label_env.txt

# Generate LABEL_CHECK section
echo "          # --- LABEL_CHECK_START ---" > /tmp/label_check.txt
while IFS= read -r label; do
  [ -z "$label" ] && continue

  # Skip non-customization labels
  if ! echo "$label" | grep -q "^🎨"; then
    continue
  fi

  var_name=$(echo "$label" | sed 's/^[^a-zA-Z]*//' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
  [ -z "$var_name" ] && continue

  env_var_name=$(echo "$var_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_')

  echo "          if [ \"\$INPUT_LABEL_${env_var_name}\" == \"true\" ]; then" >> /tmp/label_check.txt
  echo "            LABELS=\$(echo \"\$LABELS\" | jq '. + [\"${label}\"]')" >> /tmp/label_check.txt
  echo "          fi" >> /tmp/label_check.txt
done < "$LABELS_FILE"
echo "          # --- LABEL_CHECK_END ---" >> /tmp/label_check.txt

echo "Generated sections:"
echo "=== INPUTS ==="
cat /tmp/label_inputs.txt
echo ""
echo "=== ENV ==="
cat /tmp/label_env.txt
echo ""
echo "=== CHECK ==="
cat /tmp/label_check.txt
