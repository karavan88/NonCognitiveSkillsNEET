# Define the path of the new directory and placeholder file
dir_path <- getwd()
placeholder_file <- file.path(dir_path, ".gitkeep")

# Function to recursively add .gitkeep to all subdirectories of a given directory
add_gitkeep_to_all_subdirs <- function(base_dir) {
  # List all directories within the base directory recursively
  dirs <- list.dirs(path = base_dir, full.names = TRUE, recursive = TRUE)
  
  # Filter out the base directory since we only want the subdirectories
  dirs <- dirs[dirs != base_dir]
  
  # Iterate over the directories and create a .gitkeep in each
  for (dir in dirs) {
    # Define the path to the .gitkeep file within the directory
    gitkeep_path <- file.path(dir, ".gitkeep")
    
    # Check if the .gitkeep file already exists to avoid overwriting it
    if (!file.exists(gitkeep_path)) {
      # Create the .gitkeep file
      file.create(gitkeep_path)
    }
  }
  
  cat("Added .gitkeep to all subdirectories of", base_dir, "\n")
}

# Call the function with the path to the base directory where you want to add .gitkeep files
# Replace "path/to/your/directory" with your actual base directory path
add_gitkeep_to_all_subdirs(dir_path)


dir_path <- getwd()
filename <- "my_file1.txt"
full_path <- file.path(dir_path, filename)

file.create(full_path)