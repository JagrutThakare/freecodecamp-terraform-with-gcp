# Bucket to store website
resource "google_storage_bucket" "website" {
  provider = google
  name     = "example-jagrut-coffee7"
  location = "asia-south1"
}

# Make new objects public 
resource "google_storage_object_access_control" "public_rule" {
  object = google_storage_bucket_object.static_site_src.output_name
  bucket = google_storage_bucket.website.name
  role   = "READER"
  entity = "allUsers"
}

# Upload the html file to the bucket
resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "../website/index.html"
  bucket = google_storage_bucket.website.name
  
}

# Add bucket as a CDN backend
resource "google_compute_backend_bucket" "website_backend" {
  name        = "website-backend"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true
}