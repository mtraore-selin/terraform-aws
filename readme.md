### Step 1: Store AWS Credentials in GitHub Secrets

1. Go to your GitHub repository.
2. Click on `Settings`.
3. In the left sidebar, click on `Secrets and variables` > `Actions`.
4. Click on `New repository secret`.
5. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID.
   - `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key.

### Step 2: Create a GitHub Actions Workflow

1. In your repository, create a new directory called `.github/workflows` if it doesn't already exist.
2. Inside the `workflows` directory, create a new file called `terraform.yml`.

### Step 3: Define the GitHub Actions Workflow

Add the following content to `terraform.yml`:

```yaml
name: "Terraform"

on:
  push:
    branches:
      - main

jobs:
  terraform:
    name: "Terraform"
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.0.0 #

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-north-1

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

### Step 4: Commit and Push Your Changes

1. Commit the `terraform.yml` file to your repository.
2. Push the changes to your default branch (e.g., `main`).

### Explanation of the Workflow

- **Checkout code**: This step checks out your repository's code.
- **Set up Terraform**: This step sets up Terraform using the specified version.
- **Configure AWS credentials**: This step configures the AWS credentials using the secrets stored in GitHub.
- **Terraform Init**: This step initializes Terraform.
- **Terraform Plan**: This step creates an execution plan for Terraform.
- **Terraform Apply**: This step applies the Terraform configuration to create the EC2 instance.

### Additional Considerations

- **State Management**: Consider using remote state storage (e.g., AWS S3 with DynamoDB for locking) to manage your Terraform state files.
- **Security**: Ensure that your AWS credentials have the minimum required permissions to create the EC2 instance.

With this setup, every time you push changes to your default branch, the GitHub Actions workflow will run and apply your Terraform configuration to create the EC2 instance.

### TODO: Implement

- \*\* before applying, destroy
- \*\* add mongodb connection string to github secret
