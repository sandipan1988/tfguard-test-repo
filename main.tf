provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "tfguard-test-insecure-bucket"
  acl    = "private" # Remedied: Restricted access

  tags = {
    Name        = "Secured Bucket"
    Environment = "Test"
  }

  lifecycle_rule {
    id      = "cleanup-old-objects"
    enabled = true

    expiration {
      days = 90
    }
  }
}

resource "aws_security_group" "secure_sg" {
  name        = "secure_sg"
  description = "Allow only HTTPS inbound"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Remedied: Restricted to internal network
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- GCP TESTING (Premium Only) ---

resource "google_storage_bucket" "test_bucket" {
  name     = "test-bucket-no-ubla"
  location = "US"
  # Vulnerability: Uniform bucket-level access is disabled
  uniform_bucket_level_access = false 
}

resource "google_compute_instance" "test_instance" {
  name         = "test-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    # Vulnerability: Assigning a public IP address
    access_config {
      # Empty block assigns an ephemeral external IP
    }
  }
}

# --- OCI TESTING (Premium Only) ---

resource "oci_objectstorage_bucket" "public_bucket" {
    compartment_id = "ocid1.compartment.oc1..test"
    name           = "public_bucket"
    namespace      = "test_ns"
    # Vulnerability: Public access enabled
    access_type    = "ObjectRead" 
}

resource "oci_database_autonomous_database" "test_db" {
    compartment_id           = "ocid1.compartment.oc1..test"
    db_name                  = "testdb"
    cpu_core_count           = 1
    data_storage_size_in_tbs = 1
    # Vulnerability: Publicly accessible database
    is_public                = true
}
