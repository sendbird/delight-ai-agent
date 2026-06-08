import { render, screen } from '@testing-library/react';
import { vi } from 'vitest';

import App from '../App';

// Mock the Delight AI Agent Messenger React component
vi.mock('@sendbird/ai-agent-messenger-react', () => ({
  FixedMessenger: ({ appId, aiAgentId }: { appId: string; aiAgentId: string }) => (
    <div data-testid="fixed-messenger" data-app-id={appId} data-ai-agent-id={aiAgentId}>
      Mocked FixedMessenger
    </div>
  ),
  AnonymousSessionInfo: class AnonymousSessionInfo {},
  ManualSessionInfo: class ManualSessionInfo {},
}));

describe('App', () => {
  it('renders the main heading', () => {
    render(<App />);
    expect(screen.getByText('React SDK Interactive Playground')).toBeInTheDocument();
  });

  it('renders the playground controls', () => {
    render(<App />);
    expect(screen.getByText('Authentication')).toBeInTheDocument();
    expect(screen.getByText('Language')).toBeInTheDocument();
    expect(screen.getByText('Context')).toBeInTheDocument();
    expect(screen.getByText('Runtime Context Updates')).toBeInTheDocument();
  });

  it('renders the FixedMessenger component with correct props', () => {
    render(<App />);
    const messenger = screen.getByTestId('fixed-messenger');
    expect(messenger).toBeInTheDocument();
    expect(messenger).toHaveAttribute('data-app-id', 'F7879BE3-A59C-4134-A04A-702A1E62A9C0');
    expect(messenger).toHaveAttribute('data-ai-agent-id', '9ec48481-26d4-41b3-a3d7-68f20c0aeb1c');
  });

  it('renders the playground description', () => {
    render(<App />);
    expect(screen.getByText('Learn how to integrate Delight AI Agent Messenger with React')).toBeInTheDocument();
  });

  it('renders the tab navigation', () => {
    render(<App />);
    expect(screen.getByText('Interactive Playground')).toBeInTheDocument();
    expect(screen.getByText('Code Examples')).toBeInTheDocument();
  });
});
