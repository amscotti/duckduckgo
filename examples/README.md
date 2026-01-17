# Examples

This folder contains example scripts demonstrating how to use the DuckDuckGo Crystal library.

## Running Examples

From the project root directory:

```bash
# Basic usage
crystal examples/basic.cr

# Zero-click info (simplest API)
crystal examples/zci.cr

# Response types (article, disambiguation, category, etc.)
crystal examples/response_types.cr

# Instant answers (calculator, IP, password generator, etc.)
crystal examples/instant_answers.cr

# !Bang redirects
crystal examples/bang_redirects.cr

# Configuration options
crystal examples/configuration.cr
```

## Example Descriptions

| File | Description |
|------|-------------|
| `basic.cr` | Simple queries demonstrating core functionality |
| `zci.cr` | Zero-click info - get the best answer in one line |
| `response_types.cr` | Handling different API response types |
| `instant_answers.cr` | Calculator, conversions, password generation, etc. |
| `bang_redirects.cr` | !Bang shortcuts to external sites |
| `configuration.cr` | Client configuration and error handling |

## Notes

- Examples make real API calls to DuckDuckGo
- Some instant answers depend on DuckDuckGo's backend and may vary
- Rate limiting may apply for rapid successive queries
