# Pull request reviews

on:
  pull_request_review:
    types: [submitted, edited, dismissed]

# Once the workflow is triggered, you can use if conditional to check the state of review and run specific tasks based on the result.

jobs:
  test:
    runs-on: ubuntu-latest
    if: github.event.review.state == 'approved'
    steps:
      - run: npm test

# Issues
- The issues event type is used to trigger a workflow when an issue is opened, edited, deleted, transferred, pinned, unpinned, closed, reopened, assigned, unassigned, labeled, or unlabeled. This event type is particularly useful for tracking the progress of issues and ensuring that all necessary actions are taken in response to these events.

name: Issue Workflow
on:
  issues:
    types: [opened]
jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2
      - name: Run Script
        run: |
          echo "New issue has been opened!"

# Label

name: label-triggered-workflow

on:
  # Trigger the workflow when a label is created or modified in the repository.
  issues:
    types: [labeled]
  pull_request:
    types: [labeled]

jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - name: My Action
        run: echo "My Action was executed!"

# Watch

name: star-triggered-workflow

on:
  # Trigger the workflow when someone stars the repository
  watch:
    types: started

jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - name: My Action
        run: echo "My Action was executed!"

# Status
name: Build and Deploy
on:
  status
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Build app
        run: npm build
      - name: Deploy app
        if: github.event.state == 'success'
        run: npm deploy

# Configure manual launch for workflows

"workflow_dispatch is a triggering mechanism in GitHub Actions that lets you manually initiate a GitHub Action without the need to push changes or create a pull request. The workflow is manually triggered within the same repository. An added advantage is the ability to pass custom parameters during the manual trigger process.

The workflow_dispatch event does not have specific activity types. It serves as a general-purpose event for manually triggering workflows.

To utilize workflow_dispatch, you must include it within the on section of your workflow file."


name: Manual trigger

on:
  workflow_dispatch:
    inputs:
      name:
        description: "Whom to greet"
        default: "World"

jobs:
  hello:
    runs-on: ubuntu-latest
    steps:
      - name: Hello Step 
        run: echo "Hello ${{ github.event.inputs.name }}" 

# Configure dependencies between workflows

In the build.yml workflow:

name: Build
on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Hello Step 
        run: echo "Foo bar"

In the test.yml workflow:

name: Test

on:
  workflow_run:
    workflows: [Build]
    types: [completed]

jobs:
  on-success:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
      - name: Print Success Message
        run: echo 'The triggering workflow passed'

  on-failure:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'failure' }}
    steps:
      - name: Print Failure Message
        run: echo 'The triggering workflow'

# Running reusable workflows
`workflow_call is a mechanism in GitHub Actions that allows you to invoke and reuse another workflow within the same repository or across repositories. It enables modular workflow design by encapsulating a set of actions and steps as a separate workflow, which can be called from other workflows.`


The workflow_call event does not have specific activity types. It serves as a means to invoke and execute reusable workflows.

You should utilize the workflow_call feature in scenarios where you want to create reusable and modular workflows as the feature promotes code organization and reduces duplication. Some common use cases for workflow_call include:

Code reusability: Invoking a shared set of actions and steps across multiple workflows, ensuring consistency and reducing maintenance efforts.

Workflow composition: Composing complex workflows by invoking smaller, modular workflows, resulting in more manageable and maintainable CI/CD pipelines.

Centralized logic: Extracting common logic and configurations into separate workflows and invoking them from multiple workflows, improving code organization and reducing redundancy.

In the ping.yml workflow:

name: Workflow A (Ping)
on:
  push:
    branches:
      - main

jobs:
  ping:
    uses: USER_OR_ORG_NAME/REPO_NAME/.github/workflows/pong.yaml@master
    with:
      ping: 'PONG'


In the pong.yml workflow:

name: Workflow B (Pong)
on:
  workflow_call:
    inputs:
      ping:
        required: true
        type: string

jobs:
  pong:
    runs-on: ubuntu-latest
    steps:
      - name: Pong
        run: echo "${{ inputs.ping }}"

In this example, the ping.yml workflow defines a job that utilizes workflow_call to invoke the pong.yml workflow. The pong.yml workflow expects input parameter ping which is passed from the ping.yml workflow.

# Using REST API to launch workflows

name: Remote Dispatch Responder (Repository A)

on: repository_dispatch

jobs:
  ping-pong:
    runs-on: ubuntu-latest
    steps:
      - name: Event Information
        run: |
          echo "Event '${{ github.event.action }}' received from '${{ github.event.client_payload.repository }}'"


name: Remote Dispatch Action (Repository B)

on:
  push:

jobs:
  ping-pong:
    runs-on: ubuntu-latest
    steps:
      - name: PING 
        run: |
          curl -L \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: token ${{secrets.ACCESS_TOKEN}}"\
            -H "X-GitHub-Api-Version: 2022-11-28" \
            https://api.github.com/repos/OWNER/REPO/dispatches \
            -d '{"event_type": "ping", "client_payload": { "repository": "'"$GITHUB_REPOSITORY"'" }}'