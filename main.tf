# Root-level orchestration file
#
# This file can be used to call all modules or can remain empty if using environment-specific main.tf files
# For environment-specific deployments, use Environments/{Development|Staging|Production}/main.tf instead
#
# The modular structure of this project allows for flexible deployment patterns:
# - Option 1: Deploy from root level by adding module calls here
# - Option 2: Deploy from environment-specific directories (recommended approach)
#
# When using environment-specific deployments, this file can remain minimal or empty
# as the orchestration is handled at the environment level.
