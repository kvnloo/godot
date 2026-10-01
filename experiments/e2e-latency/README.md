# High-polling input pipeline experiment

Godot PR 109639 merged on 2026-08-08 and targeted the Windows performance problem caused by very high mouse report rates. The merge commit is:

`f460a42dcdd066936dd80796e6a2555554250e9d`

Related reports include issues 60646 and 120390.

## Goal

Measure what changed across the fix and identify any remaining latency tradeoff.

## Revisions

Compare:

1. a revision immediately before the merged fix;
2. `f460a42d`;
3. current master.

Use optimized builds.

## Matrix

Where the hardware supports it:

- 125 / 1000 / 2000 / 4000 / 8000 Hz
- relative/captured mouse mode and normal pointer mode
- `Input.use_accumulated_input` on/off
- VSync on/off
- 60 / 144 / 240+ FPS caps

Use the same minimal reproduction workload for all runs.

## Capture

Record:

- frame-time p50/p95/p99/p99.9
- process CPU
- OS input-message processing time if instrumented
- engine mouse-event callbacks per second
- integrated relative-motion total
- newest input age at the simulation step where measurable

The important question is not only whether batching raises FPS. Measure whether it keeps the newest usable input fresh.

## Editor follow-up

Issue 104551 reports large visible delay while dragging 2D editor objects. Use the same timestamp decomposition there. If event dispatch is already fresh, inspect the editor/render path instead of the input backend.

## Promotion

None from this branch. This is an evidence packet only.
