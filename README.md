# anim_audit

**One capability bit from GBT V8, packaged standalone.** No. 9 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 动画体检（**纯读免门**）：直接解析 GLB 的 animation 通道，把每根骨「首帧 vs 静止姿势」的夹角从大到小排出来（当初就是它量出髋骨被扭 177.2°/176.3°）。阈值 --threshold 默认 30°，all 打全量。op=status/run/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-anim-audit.git
cd gbt-anim-audit
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_anim_audit info                  # capability card
python -m gbt_anim_audit spec --json           # machine-readable contract
python -m gbt_anim_audit check --payload '{}'
python -m gbt_anim_audit run   --payload '{}'
```

Real `info` output from this machine:

```text
anim_audit  (creation)  v1.0.0
----------------------------------------
动画体检（**纯读免门**）：直接解析 GLB 的 animation 通道，把每根骨「首帧 vs 静止姿势」的夹角从大到小排出来（当初就是它量出髋骨被扭 177.2°/176.3°）。阈值 --threshold 默认 30°，all 打全量。op=status/run/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : status, run, where
```

Wire a real implementation:

```python
from gbt_anim_audit import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`status`、`run`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.14s
```

## Provenance

| field | value |
|---|---|
| capability | `anim_audit` |
| domain | `creation` |
| handler | `dh_rig` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [creation/anim_audit](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/anim_audit.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
