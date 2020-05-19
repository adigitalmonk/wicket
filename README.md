# Wicket

Elixir Port wrapper helper.

## Requirements

- Elixir >= 1.10
- Runner implemented in your language of choice

## Usage

```elixir
iex> Wicket.run("34 ** 34")
11756638905368616011414050501310355554617941909569536
```

## Configuration

```elixir
config :wicket,
  runtime: "python3",
  runner: "priv/runner/main.py",
  pool_size: 1,
  max_overflow: 0
```

### Runner Spec

Yet to be written.

- Input vs. Output
- Mode settings

```elixir
config :wicket,
  runtime: "python3",
  runner: "priv/runners/main.py",
  mode: :nouse_stdio
```

```python
import os
from json import dumps

ID_LEN = 32

with os.fdopen(3, "r") as in_stream, os.fdopen(4, "w") as out_stream:
    while True:
        payload = "".join([character for character in in_stream.readline()])
        req_id = payload[:ID_LEN]
        command = payload[ID_LEN:]
        out_stream.write(f"{req_id}{dumps(eval(command))}")
        out_stream.flush()
```

## To Do

Telemetry events

# Further Reading:

- <https://www.theerlangelist.com/article/outside_elixir>
- <https://www.poeticoding.com/real-time-object-detection-with-phoenix-and-python/>
