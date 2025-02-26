# meridian_mmm_on_snowflake

## Overview
In January 2025, Google released the Meridian MMM package as an open-source marketing mix model powered by Bayesian causal inference. It is an impressive model and will further help organizations measure the results of their marketing across many different media forms. This is made more important with increasing walled gardens spreading in the media/advertising world!

This repository contains SQL code and a Python Notebook that can be run within the Snowflake environment to recreate the Meridian Getting Started Tutorial.

## Usage

### Prerequisites
* Snowflake account with privileges to create roles, compute pools, databases/schemas, etc.
* Data in proper formats for the Meridian model - you can use the tutorial data provided by the Meridian package, if not.

### Step 1: Run the `setup.sql` script within a Snowflake SQL worksheet
This will create a new role with permissions to create a compute pool and db objects. It will also create and external access integration that will allow the Snowflake Notebook to connect to PyPI and Github for the latest Meridian model releases.

### Step 2: Import the Notebook and Run the steps
You will need to import the Notebook in this repo and create a Container Runtime Snowflake Notebook. These are currently in public preview in AWS and Azure regions. The notebook follows the same steps as the Meridian Getting Started tutorial, however, some tutorial typos and bugs have already been fixed for you.
