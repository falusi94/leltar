import { closeOpenNavbarDropdown } from './closeOpenNavbarDropdown'

document.addEventListener('turbo:before-cache', closeOpenNavbarDropdown)
