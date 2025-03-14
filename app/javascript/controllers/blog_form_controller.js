import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "title", 
    "slug", 
    "imageInput", 
    "imagePlaceholder", 
    "formErrors", 
    "errorList",
    "publishedAtContainer"
  ]

  connect() {
    console.log("Blog form controller connected")
    
    // If no published_at value is set and published is checked, set published_at to now
    if (this.element.querySelector("#post_published:checked") && !this.element.querySelector("#post_published_at").value) {
      const now = new Date().toISOString().slice(0, 16);
      this.element.querySelector("#post_published_at").value = now;
    }
  }

  generateSlug() {
    if (!this.hasSlugTarget || !this.hasTitleTarget) return;
    
    const title = this.titleTarget.value;
    if (!title) return;
    
    // Only autogenerate if user hasn't manually entered a slug
    if (this.slugTarget.value && this.slugManuallyChanged) return;
    
    const slug = title
      .toLowerCase()
      .replace(/[^\w\s]/gi, '')  // Remove special chars
      .replace(/\s+/g, '-')      // Replace spaces with hyphens
      .replace(/-+/g, '-')       // Replace multiple hyphens with single hyphen
      .substring(0, 60);         // Limit length
      
    this.slugTarget.value = slug;
  }
  
  previewImage(event) {
    if (!this.hasImagePlaceholderTarget) return;
    
    const file = event.target.files[0];
    if (!file) return;
    
    // Check if file is an image
    if (!file.type.match('image.*')) {
      this.showError("Selected file is not an image.");
      return;
    }
    
    const reader = new FileReader();
    
    reader.onload = (e) => {
      // Replace placeholder with preview
      this.imagePlaceholderTarget.innerHTML = `
        <div class="w-full h-full relative group">
          <img src="${e.target.result}" class="w-full h-full object-cover" />
          <div class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
            <button type="button" data-action="blog-form#removeFeaturedImage" class="text-white bg-red-600 rounded-full p-1.5 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
        </div>
      `;
    };
    
    reader.readAsDataURL(file);
  }
  
  removeFeaturedImage(event) {
    event.preventDefault();
    
    if (this.hasImageInputTarget && this.hasImagePlaceholderTarget) {
      // Clear the file input
      this.imageInputTarget.value = '';
      
      // Reset the placeholder
      this.imagePlaceholderTarget.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      `;
    }
  }
  
  handleSubmit(event) {
    // This method will be triggered by turbo:submit-end 
    if (event.detail.success) {
      // Redirect handled by Turbo
    } else {
      // Show validation errors
      const errors = JSON.parse(event.detail.fetchResponse.response.body);
      this.showErrors(errors);
    }
  }
  
  showErrors(errors) {
    if (!this.hasFormErrorsTarget || !this.hasErrorListTarget) return;
    
    // Clear existing errors
    this.errorListTarget.innerHTML = '';
    
    // Add each error to the list
    Object.entries(errors).forEach(([field, messages]) => {
      messages.forEach(message => {
        const li = document.createElement('li');
        li.textContent = `${field.charAt(0).toUpperCase() + field.slice(1)} ${message}`;
        this.errorListTarget.appendChild(li);
      });
    });
    
    // Show the error container
    this.formErrorsTarget.classList.remove('hidden');
    
    // Scroll to errors
    this.formErrorsTarget.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  
  showError(message) {
    if (!this.hasFormErrorsTarget || !this.hasErrorListTarget) return;
    
    // Clear existing errors
    this.errorListTarget.innerHTML = '';
    
    // Add the error message
    const li = document.createElement('li');
    li.textContent = message;
    this.errorListTarget.appendChild(li);
    
    // Show the error container
    this.formErrorsTarget.classList.remove('hidden');
  }
  
  togglePublishedAt(event) {
    if (!this.hasPublishedAtContainerTarget) return;
    
    const isChecked = event.target.checked;
    
    if (isChecked) {
      // Show published_at field
      this.publishedAtContainerTarget.classList.remove('hidden');
      
      // Set current time if empty
      const publishedAtField = this.element.querySelector("#post_published_at");
      if (publishedAtField && !publishedAtField.value) {
        const now = new Date().toISOString().slice(0, 16);
        publishedAtField.value = now;
      }
    } else {
      // Hide published_at field
      this.publishedAtContainerTarget.classList.add('hidden');
    }
  }
  
  get slugManuallyChanged() {
    return this._slugManuallyChanged || false;
  }
  
  set slugManuallyChanged(value) {
    this._slugManuallyChanged = value;
  }
}