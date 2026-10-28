#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_anim_audit info
PYTHONPATH=src python -m gbt_anim_audit check --payload '{}'
PYTHONPATH=src python -m gbt_anim_audit run   --payload '{}'
