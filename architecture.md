# UniStudy Organizer - Architecture Plan

## Overview
A university study organization app with 6 subject categories. Each category supports notes, images, files, ideas, and quizzes with offline storage using local shared preferences.

## Core Features (MVP)
1. Main menu with 6 customizable subject categories
2. Per category: text notes, image storage, file uploads, quick ideas, quiz system
3. Offline functionality with local storage
4. Clean, minimal UI design

## Technical Architecture

### File Structure
- `main.dart` - App entry point & navigation
- `models/` - Data models (Subject, Note, Quiz, etc.)
- `services/` - Storage service for local persistence
- `screens/` - UI screens (Home, Subject Detail, etc.)
- `widgets/` - Reusable UI components

### Data Models
- Subject: id, name, icon, color
- Note: id, subjectId, title, content, createdAt
- QuickIdea: id, subjectId, text, createdAt
- Quiz: id, subjectId, title, questions
- Question: text, options, correctAnswer
- StudyFile: id, subjectId, name, path, type

### Key Implementation Steps
1. Add required dependencies (shared_preferences, file_picker, image_picker)
2. Create data models and storage service
3. Build main home screen with subject grid
4. Implement subject detail screen with content tabs
5. Add CRUD operations for each content type
6. Include sample data for demonstration
7. Test and compile project

### Storage Strategy
- SharedPreferences for JSON serialized data
- Local file system for uploaded images/documents
- All data persists between app sessions

### UI Design
- Material 3 design with purple academic theme
- Grid layout for subjects on home screen
- Tab-based navigation within subjects
- Card-based layouts for content items
- Floating action buttons for adding content