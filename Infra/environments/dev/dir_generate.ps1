$folders = @(
    "enviroments\dev",
    "enviroments\prod",
    "modules\ec2",
    "modules\lambda",
    "modules\rds",
    "modules\vpc"
)
New-Item -ItemType Directory -Force -Path $folders