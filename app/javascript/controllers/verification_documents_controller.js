import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "fileList"]
  
  connect() {
    console.log("Verification documents controller connected")
  }
  
  displayFileNames() {
    const fileList = this.inputTarget.files
    
    if (!fileList || fileList.length === 0) return
    
    // Create the file list container
    const container = document.createElement("div")
    container.className = "text-sm text-gray-700 dark:text-gray-300 mt-3"
    
    const heading = document.createElement("p")
    heading.className = "font-medium mb-1"
    heading.textContent = "Selected Files:"
    container.appendChild(heading)
    
    const list = document.createElement("ul")
    list.className = "list-disc pl-5"
    
    // Add each file to the list
    Array.from(fileList).forEach(file => {
      const item = document.createElement("li")
      item.textContent = file.name
      list.appendChild(item)
    })
    
    container.appendChild(list)
    
    // Clear the previous file list and add the new one
    if (this.hasFileListTarget) {
      this.fileListTarget.innerHTML = ''
      this.fileListTarget.appendChild(container)
    }
  }
}