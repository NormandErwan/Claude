# Skills with Executable Code

Reference for authoring skills that bundle executable scripts alongside instruction files.
If your skill uses only markdown instructions, this document does not apply.

---

## Solve, don't punt

When writing scripts for skills, handle error conditions rather than punting to Claude.

**Good: Handle errors explicitly**

```python
def process_file(path):
    """Process a file, creating it if it doesn't exist."""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # Create file with default content instead of failing
        print(f"File {path} not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # Provide alternative instead of failing
        print(f"Cannot access {path}, using default")
        return ''
```

**Bad: Punt to Claude**

```python
def process_file(path):
    # Just fail and let Claude figure it out
    return open(path).read()
```

Configuration parameters should also be justified and documented to avoid "voodoo constants"
(Ousterhout's law). If you don't know the right value, how will Claude determine it?

**Good: Self-documenting**

```python
# HTTP requests typically complete within 30 seconds
# Longer timeout accounts for slow connections
REQUEST_TIMEOUT = 30

# Three retries balances reliability vs speed
# Most intermittent failures resolve by the second retry
MAX_RETRIES = 3
```

**Bad: Magic numbers**

```python
TIMEOUT = 47  # Why 47?
RETRIES = 5   # Why 5?
```

---

## Provide utility scripts

Even if Claude could generate a script, pre-made scripts are better:

* More reliable than generated code
* Save tokens (no need to include code in context)
* Save time (no code generation required)
* Ensure consistency across uses

The instruction file references the script by path; Claude executes it via bash without loading
the script's contents into context — only the output consumes tokens.

**Important distinction**: Make clear in your SKILL.md whether Claude should:

* **Execute the script** (most common): "Run `analyze_form.py` to extract fields"
* **Read it as reference** (for complex logic): "See `analyze_form.py` for the field extraction algorithm"

For most utility scripts, execution is preferred.

**Example SKILL.md section:**

```markdown
## Utility scripts

**analyze_form.py**: Extract all form fields from PDF

    python scripts/analyze_form.py input.pdf > fields.json

Output format:

    {"field_name": {"type": "text", "x": 100, "y": 200}, ...}

**validate_boxes.py**: Check for overlapping bounding boxes

    python scripts/validate_boxes.py fields.json
    # Returns: "OK" or lists conflicts

**fill_form.py**: Apply field values to PDF

    python scripts/fill_form.py input.pdf fields.json output.pdf
```

---

## Use visual analysis

When inputs can be rendered as images, have Claude analyze them visually:

```markdown
## Form layout analysis

1. Convert PDF to images:
   python scripts/pdf_to_images.py form.pdf
2. Analyze each page image to identify form fields
3. Claude can see field locations and types visually
```

Claude's vision capabilities help understand layouts and structures.

---

## Create verifiable intermediate outputs

The "plan-validate-execute" pattern catches errors before they cause damage.

**Example**: Updating 50 form fields from a spreadsheet.
Without validation, Claude might reference non-existent fields, create conflicting values, or miss required fields.

**Solution**: Insert a validation step before execution.

Workflow: analyze → **create plan file** → **validate plan** → execute → verify.

**Why it works:**

* **Catches errors early**: Validation runs before changes are applied
* **Machine-verifiable**: Scripts provide objective pass/fail
* **Reversible planning**: Claude iterates on the plan file without touching originals
* **Clear debugging**: Error messages name the exact problem

**When to use**: Batch operations, destructive changes, complex validation rules, high-stakes work.

**Tip**: Make validation scripts verbose with specific messages, e.g.:
`"Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed"`

---

## Package dependencies

Skills run with platform-specific limitations:

* **claude.ai**: Can install packages from npm and PyPI, pull from GitHub repositories
* **Anthropic API**: No network access, no runtime package installation

List required packages in SKILL.md and verify they are available before shipping.

---

## Runtime environment

Skills run in a code execution environment with filesystem access, bash commands, and code
execution capabilities.

**How Claude accesses a skill:**

1. **Metadata pre-loaded**: At startup, `name` and `description` from all skills' YAML frontmatter
   load into the system prompt
2. **Files read on-demand**: Claude reads SKILL.md and supporting files from the filesystem when needed
3. **Scripts executed efficiently**: Scripts run via bash; only their output consumes tokens, not
   the script source
4. **No context penalty for large files**: Reference files, data, or docs stay on disk until
   actually read

**Authoring implications:**

* **File paths matter**: use forward slashes (`reference/guide.md`), not backslashes
* **Name files descriptively**: `form_validation_rules.md`, not `doc2.md`
* **Organize for discovery**: `reference/finance.md`, `reference/sales.md` — not `docs/file1.md`
* **Bundle comprehensive resources**: large API docs, extensive examples; no context cost until read
* **Prefer scripts for deterministic operations**: ship `validate_form.py` rather than asking
  Claude to generate validation code each time
* **Declare execution intent**:
  * "Run `analyze_form.py` to extract fields" (execute)
  * "See `analyze_form.py` for the extraction algorithm" (read as reference)
* **Test file access patterns**: verify Claude can navigate your directory structure with real requests

**Example directory with progressive disclosure:**

```
bigquery-skill/
├── SKILL.md              (overview, points to reference files)
└── reference/
    ├── finance.md        (revenue metrics)
    ├── sales.md          (pipeline data)
    └── product.md        (usage analytics)
```

When the user asks about revenue, Claude reads SKILL.md, sees the pointer to `reference/finance.md`,
and loads only that file. The others stay on disk, consuming zero context tokens until needed.

---

## MCP tool references

If your skill uses MCP (Model Context Protocol) tools, always use fully qualified tool names to
avoid "tool not found" errors.

**Format**: `ServerName:tool_name`

```markdown
Use the BigQuery:bigquery_schema tool to retrieve table schemas.
Use the GitHub:create_issue tool to create issues.
```

Without the server prefix, Claude may fail to locate the tool when multiple MCP servers are active.

---

## Avoid assuming tools are installed

**Bad: Assumes installation**

```markdown
Use the pdf library to process the file.
```

**Good: Explicit about dependencies**

```markdown
Install required package: `pip install pypdf`

Then use it:
    from pypdf import PdfReader
    reader = PdfReader("file.pdf")
```

---

## Technical notes

### YAML frontmatter limits

`name`: 64 characters max. `description`: 1024 characters max.

### Line budget

Keep SKILL.md body under 500 lines for optimal performance. If it exceeds this, split content
into separate files using progressive disclosure patterns.

---

## Checklist — Code and scripts

Before shipping a skill with executable code:

* [ ] Scripts solve problems rather than punt to Claude
* [ ] Error handling is explicit and helpful
* [ ] No "voodoo constants" — all magic values are justified with comments
* [ ] Required packages listed in SKILL.md and verified as available
* [ ] Scripts have clear documentation
* [ ] No Windows-style paths (forward slashes only)
* [ ] Validation or verification steps added for critical operations
* [ ] Feedback loops included for quality-critical tasks
* [ ] Execution vs. read-as-reference intent is explicit for every script reference
