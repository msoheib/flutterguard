// User Types
type UserRole = 'user' | 'company' | 'admin' | 'super_admin';

// Collections Structure
interface Collections {
  users: {
    uid: string;
    email: string;
    phoneNumber: string;
    role: UserRole;
    joinDate: Timestamp;
    name: string;
    profileImage?: string;
    isActive: boolean;
    deviceTokens: string[];
    lastLogin: Timestamp;
  };

  companies: {
    id: string;
    name: string;
    email: string;
    phoneNumber: string;
    description: string;
    logo?: string;
    website?: string;
    location: string;
    createdAt: Timestamp;
    isVerified: boolean;
    isActive: boolean;
    totalJobs: number;
    industry: string;
    size: string;
  };

  jobs: {
    id: string;
    companyId: string;
    title: string;
    description: string;
    requirements: string[];
    responsibilities: string[];
    location: string;
    type: 'full-time' | 'part-time' | 'contract';
    salary: {
      min: number;
      max: number;
      currency: string;
    };
    experience: {
      min: number;
      max: number;
    };
    postedAt: Timestamp;
    expiresAt: Timestamp;
    isActive: boolean;
    applicantsCount: number;
    skills: string[];
  };

  applications: {
    id: string;
    jobId: string;
    userId: string;
    companyId: string;
    status: 'pending' | 'reviewed' | 'accepted' | 'rejected';
    appliedAt: Timestamp;
    updatedAt: Timestamp;
    resume?: string;
    coverLetter?: string;
  };

  notifications: {
    id: string;
    userId: string;
    type: 'application_update' | 'job_alert' | 'system_message';
    title: string;
    message: string;
    isRead: boolean;
    createdAt: Timestamp;
    data?: {
      jobId?: string;
      applicationId?: string;
      companyId?: string;
    };
  };

  complaints: {
    id: string;
    userId: string;
    companyId?: string;
    jobId?: string;
    type: string;
    description: string;
    status: 'open' | 'in_progress' | 'resolved' | 'closed';
    createdAt: Timestamp;
    updatedAt: Timestamp;
    priority: 'low' | 'medium' | 'high';
    assignedTo?: string;
  };
}

// Required Indexes
const requiredIndexes = {
  jobs: [
    { fields: ['companyId', 'isActive', 'postedAt'] },
    { fields: ['isActive', 'postedAt'] },
    { fields: ['location', 'isActive', 'postedAt'] },
    { fields: ['type', 'isActive', 'postedAt'] }
  ],
  
  applications: [
    { fields: ['userId', 'appliedAt'] },
    { fields: ['companyId', 'status', 'appliedAt'] },
    { fields: ['jobId', 'status'] }
  ],
  
  notifications: [
    { fields: ['userId', 'isRead', 'createdAt'] }
  ],
  
  complaints: [
    { fields: ['userId', 'createdAt'] },
    { fields: ['status', 'priority', 'createdAt'] },
    { fields: ['assignedTo', 'status', 'createdAt'] }
  ]
};

// Security Rules Structure
const securityRules = {
  "rules": {
    "users": {
      ".read": "auth != null",
      ".write": "auth != null && (resource.data.role == 'admin' || resource.data.uid == auth.uid)"
    },
    "companies": {
      ".read": "true",
      ".write": "auth != null && (resource.data.role == 'admin' || resource.data.role == 'company')"
    },
    "jobs": {
      ".read": "true",
      ".write": "auth != null && (resource.data.role == 'admin' || resource.data.companyId == auth.uid)"
    },
    "applications": {
      ".read": "auth != null && (resource.data.userId == auth.uid || resource.data.companyId == auth.uid)",
      ".write": "auth != null"
    }
  }
};
