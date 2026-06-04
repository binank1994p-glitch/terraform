# Root-level outputs aggregation
#
# This file can aggregate critical outputs from modules or remain empty if using environment-specific outputs
# For environment-specific outputs, use Environments/{Development|Staging|Production}/outputs.tf instead
#
# The modular structure of this project allows for flexible output patterns:
# - Option 1: Aggregate key outputs here for root-level deployments
# - Option 2: Use environment-specific output files (recommended approach)
#
# When using environment-specific deployments, this file can remain minimal or empty
# as the output aggregation is handled at the environment level.
