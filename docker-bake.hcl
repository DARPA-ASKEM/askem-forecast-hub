variable "DOCKER_REGISTRY" {
  default = "ghcr.io"
}
variable "DOCKER_ORG" {
  default = "darpa-askem"
}
variable "VERSION" {
  default = "latest"
}

# ----------------------------------------------------------------------------------------------------------------------

function "buildtag" {
  params = [image_name, prefix, suffix]
  result = [ "${DOCKER_REGISTRY}/${DOCKER_ORG}/${image_name}:${check_prefix(prefix)}${VERSION}${check_suffix(suffix)}", "${image_name}:build" ]
}

function "tag" {
  params = [image_name, prefix, suffix]
  result = [ "${DOCKER_REGISTRY}/${DOCKER_ORG}/${image_name}:${check_prefix(prefix)}${VERSION}${check_suffix(suffix)}" ]
}

function "check_prefix" {
  params = [tag]
  result = notequal("",tag) ? "${tag}-": ""
}

function "check_suffix" {
  params = [tag]
  result = notequal("",tag) ? "-${tag}": ""
}

# ----------------------------------------------------------------------------------------------------------------------

group "prod" {
  targets = ["askem-forecast-hub"]
}

group "default" {
  targets = ["askem-forecast-hub-base"]
}

# ----------------------------------------------------------------------------------------------------------------------

target "_platforms" {
  platforms = ["linux/amd64","linux/arm64"]
}

target "askem-forecast-hub-base" {
	context = "."
	tags = tag("askem-forecast-hub", "", "")
	dockerfile = "Dockerfile"
}

target "askem-forecast-hub" {
  inherits = ["_platforms", "askem-forecast-hub-base"]
}
