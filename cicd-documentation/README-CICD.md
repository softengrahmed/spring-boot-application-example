# Spring Boot CI/CD Pipeline Documentation

## Overview

This repository contains a comprehensive CI/CD pipeline for the Spring Boot application, implementing modern DevOps practices with AWS ECS/Fargate deployment.

**Pipeline Version:** v1-2025-09-23  
**Generated:** September 23, 2025  
**Repository:** https://github.com/softengrahmed/spring-boot-application-example

## 🏗️ Architecture Overview

### Application Stack
- **Framework:** Spring Boot 1.4.3
- **Language:** Java 11
- **Build Tool:** Maven
- **Database:** H2 (development), PostgreSQL (production)
- **Container Runtime:** Docker
- **Deployment Platform:** AWS ECS with Fargate

### CI/CD Pipeline Architecture
```
Source Code → Build → Security → Quality → Deploy → Migrate → Docs → Cleanup → Report
     ↓         ↓        ↓         ↓        ↓        ↓        ↓        ↓         ↓
  GitHub    Maven    CodeQL   Coverage   ECS    Flyway  Swagger  AWS     JSON
            Tests    SAST     Gates             DB      API    Cleanup  Report
```

## 🚀 Pipeline Stages

### 1. Initialize Stage
**Purpose:** Pipeline setup and metadata configuration
- Set pipeline ID and build metadata
- Configure environment variables
- Initialize structured logging
- **Duration:** ~30 seconds

### 2. Build Stage
**Purpose:** Compile, test, and package the application
- Set up JDK 11 with Maven caching
- Compile source code
- Run unit tests with JaCoCo coverage
- Package JAR file
- Upload build artifacts
- **Duration:** 3-5 minutes
- **Artifacts:** JAR file, test reports, coverage reports

### 3. Security Stage
**Purpose:** Security scanning and vulnerability assessment
- CodeQL SAST analysis
- OWASP dependency vulnerability scanning
- Generate security reports
- **Duration:** 2-4 minutes
- **Quality Gate:** Zero critical vulnerabilities

### 4. Quality Stage
**Purpose:** Code quality validation and coverage analysis
- Test coverage analysis (minimum 80%)
- Code quality metrics
- Quality gate validation
- **Duration:** 1-2 minutes
- **Quality Gate:** Coverage ≥ 80%, no critical issues

### 5. Deploy Stage
**Purpose:** Container build and deployment to AWS ECS
- Build optimized Docker image
- Push to Amazon ECR
- Deploy to ECS with Fargate
- Health check validation
- **Duration:** 5-8 minutes
- **Environments:** dev, staging, prod

### 6. Database Migration Stage
**Purpose:** Database schema updates and migrations
- Connect to target database
- Run Flyway migrations
- Validate migration success
- **Duration:** 1-3 minutes
- **Tool:** Flyway

### 7. API Documentation Stage
**Purpose:** Generate and deploy API documentation
- Extract Swagger/OpenAPI specifications
- Generate documentation site
- Deploy documentation
- **Duration:** 1-2 minutes
- **Output:** Swagger UI

### 8. Cleanup Stage
**Purpose:** Resource optimization and cost management
- Clean up old ECR images
- Remove temporary AWS resources
- Archive old logs
- **Duration:** 2-3 minutes
- **Retention:** 14 days

### 9. Report Stage
**Purpose:** Pipeline execution reporting and metrics
- Generate execution report
- Upload artifacts
- Send notifications
- **Duration:** 30 seconds
- **Output:** JSON report

## 🌍 Environment Strategy

### Development Environment
- **Trigger:** Every push to feature branches
- **Database:** H2 in-memory
- **Resources:** 1 container, minimal resources
- **Auto-deploy:** Yes
- **Approval:** Not required

### Staging Environment
- **Trigger:** Push to main/develop branch
- **Database:** Dedicated RDS instance
- **Resources:** 1-2 containers with auto-scaling
- **Auto-deploy:** Yes
- **Approval:** Not required

### Production Environment
- **Trigger:** Release tags or manual deployment
- **Database:** Production RDS with backups
- **Resources:** 2-10 containers with auto-scaling
- **Auto-deploy:** No
- **Approval:** Required

## 🔧 Configuration Files

### Pipeline Configuration
- `.github/workflows/cicd-main-pipeline.yaml` - Main pipeline workflow
- `cicd-specifications/pipeline-specification.yaml` - Pipeline specifications
- `cicd-pipeline-configs/` - Stage-specific configurations

### Infrastructure Configuration
- `Dockerfile` - Multi-stage container build
- `cicd-infrastructure/aws-serverless-config.yaml` - AWS resource configuration
- `cicd-infrastructure/monitoring-config.yaml` - Monitoring and observability

### Security Configuration
- `cicd-pipeline-configs/security-scanning-config.yaml` - Security scanning rules
- `cicd-pipeline-configs/quality-gates.yaml` - Quality gate thresholds

### Database Configuration
- `src/main/resources/db/migration/` - Flyway migration scripts
- `pom-flyway.xml` - Flyway Maven plugin configuration

## 🔐 Security Features

### Static Application Security Testing (SAST)
- **Tool:** GitHub CodeQL
- **Languages:** Java
- **Queries:** Security and quality queries
- **Integration:** Native GitHub Security tab

### Dependency Scanning
- **Tool:** OWASP Dependency Check
- **Coverage:** All Maven dependencies
- **Threshold:** No critical vulnerabilities
- **Updates:** Dependabot automated updates

### Container Security
- **Registry:** Amazon ECR with scan-on-push
- **Base Image:** OpenJDK 11 slim
- **User:** Non-root user for container execution
- **Secrets:** AWS Secrets Manager integration

### Infrastructure Security
- **Network:** VPC with private subnets
- **Access:** IAM roles with least privilege
- **Encryption:** Data encrypted in transit and at rest
- **Monitoring:** CloudTrail and VPC Flow Logs

## 📊 Monitoring and Observability

### Application Monitoring
- **Health Checks:** `/actuator/health` endpoint
- **Metrics:** Spring Boot Actuator metrics
- **Logs:** Structured JSON logging
- **APM:** CloudWatch Application Insights

### Infrastructure Monitoring
- **Compute:** ECS container metrics
- **Database:** RDS performance insights
- **Network:** ALB request metrics
- **Storage:** S3 and EBS metrics

### Alerting
- **Critical:** Application down, database connectivity
- **Warning:** High CPU/memory, slow response times
- **Info:** Deployment status, scale events
- **Channels:** SNS, Email, Slack integration

## 💰 Cost Optimization

### Resource Management
- **Auto-scaling:** Based on CPU and memory metrics
- **Spot Instances:** For non-production workloads
- **Scheduled Scaling:** Down-scale during off-hours
- **Resource Cleanup:** Automated cleanup of unused resources

### Storage Optimization
- **Lifecycle Policies:** Automatic S3 object transitions
- **Log Retention:** 14-day retention for most logs
- **Image Cleanup:** Keep last 10 ECR images only
- **Backup Optimization:** Compressed backups with retention

### Estimated Costs
- **Development:** $15-25/month
- **Staging:** $25-40/month
- **Production:** $50-100/month
- **Total:** $90-165/month

## 🚀 Getting Started

### Prerequisites
1. AWS Account with appropriate permissions
2. GitHub repository with Actions enabled
3. Docker installed locally (for testing)
4. Maven 3.6+ and Java 11+ (for local development)

### Setup Instructions

#### 1. Configure AWS Secrets
Add these secrets to your GitHub repository:
```
AWS_ACCOUNT_ID=123456789012
AWS_ROLE_ARN=arn:aws:iam::123456789012:role/GitHubActions
DB_URL=jdbc:postgresql://hostname:5432/dbname
DB_USERNAME=dbuser
DB_PASSWORD=dbpassword
```

#### 2. Deploy Infrastructure
```bash
# Use the provided Terraform configuration
cd cicd-infrastructure/
terraform init
terraform plan
terraform apply
```

#### 3. Test Pipeline
```bash
# Push code to trigger pipeline
git add .
git commit -m "feat: test pipeline"
git push origin main
```

#### 4. Monitor Deployment
- Check GitHub Actions tab for pipeline status
- Monitor AWS CloudWatch for application health
- Access application at ALB endpoint

## 🔧 Local Development

### Running Locally
```bash
# Start application
./mvnw spring-boot:run

# Run tests
./mvnw test

# Generate coverage report
./mvnw jacoco:report

# Build Docker image
docker build -t spring-boot-app .

# Run container
docker run -p 8080:8080 spring-boot-app
```

### Database Migrations
```bash
# Run migrations locally
./mvnw flyway:migrate

# Check migration status
./mvnw flyway:info

# Validate migrations
./mvnw flyway:validate
```

## 🐛 Troubleshooting

### Common Issues

#### Pipeline Failures
1. **Build Failures:** Check Maven dependencies and Java version
2. **Test Failures:** Review test logs and fix failing tests
3. **Security Issues:** Address CodeQL findings or add exceptions
4. **Quality Gates:** Increase test coverage or fix code quality issues

#### Deployment Issues
1. **ECR Push Failures:** Verify AWS credentials and permissions
2. **ECS Deployment Failures:** Check task definition and health checks
3. **Database Connection:** Verify connection strings and security groups
4. **Health Check Failures:** Ensure `/actuator/health` endpoint is accessible

#### Monitoring Issues
1. **Missing Metrics:** Verify CloudWatch agent configuration
2. **Log Aggregation:** Check log group permissions and retention
3. **Alerts Not Working:** Verify SNS topic configuration

### Debug Commands
```bash
# Check container logs
aws logs tail /aws/ecs/spring-boot-app --follow

# Describe ECS service
aws ecs describe-services --cluster spring-boot-cluster --services spring-boot-service

# Check health status
curl http://alb-endpoint/actuator/health

# View database migrations
./mvnw flyway:info
```

## 📚 Additional Resources

### Documentation Links
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Flyway Documentation](https://flywaydb.org/documentation/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

### Monitoring Dashboards
- CloudWatch Dashboard: [Link to be provided after deployment]
- Application Health: `http://alb-endpoint/actuator/health`
- API Documentation: `http://alb-endpoint/swagger-ui.html`

### Support
- **Issues:** Create GitHub issues for bugs and feature requests
- **Security:** Report security issues to security@example.com
- **Operations:** Contact DevOps team for deployment issues

---

**Last Updated:** 2025-09-23  
**Pipeline Version:** v1  
**Maintained by:** DevOps Team