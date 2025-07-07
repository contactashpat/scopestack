#!/bin/bash

PROJECT_ROOT="scopestack"

cd $PROJECT_ROOT || { echo "❌ Folder '$PROJECT_ROOT' not found."; exit 1; }

echo "📁 Initializing Git repository..."

# Create .gitignore
cat <<EOL > .gitignore
# Java
*.class
*.jar
*.war
*.ear
target/
bin/

# Maven
.mvn/
!/.mvn/wrapper/maven-wrapper.jar
**/target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties

# IntelliJ
.idea/
*.iml
*.iws
*.ipr
out/

# Logs
*.log

# OS files
.DS_Store
Thumbs.db
EOL

# Initialize Git
git init
git add .
git commit -m "Initial commit: Scaffold ScopeStack monorepo structure"

echo "✅ Git repo initialized with initial commit."
