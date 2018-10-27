import React, { Component } from 'react';
import { Form, Button, Input, Message, Modal, Header, Icon } from 'semantic-ui-react';
import Layout from '../../components/Layout';
import factory from '../../ethereum/factory';
import web3 from '../../ethereum/web3';
import { Router } from '../../routes';

class CampaignNew extends Component {
  state = {
    minimumContribution: '',
    errorMessage: '',
    loading: false,
    modalOpen: false
  };

  handleClose = () => this.setState({ modalOpen: false });
  
  handleOpen = () => this.setState({ modalOpen: true })

  onSubmit = async event => {
    event.preventDefault();

    this.setState({ loading: true, errorMessage: '' });

    try {
      const accounts = await web3.eth.getAccounts();
      await factory.methods
        .createCampaign(this.state.minimumContribution)
        .send({
          from: accounts[0]
        });

    } catch (err) {
      this.setState({ errorMessage: err.message });
    }

    this.setState({ loading: false, modalOpen: true });
  };

  render() {
    return (
      <Layout>
        <h3>Create a Campaign</h3>

        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Minimum Contribution</label>
            <Input
              label="wei"
              labelPosition="right"
              value={this.state.minimumContribution}
              onChange={event =>
                this.setState({ minimumContribution: event.target.value })}
            />
          </Form.Field>

          <Message error header="Oops!" content={this.state.errorMessage} />
          <Button loading={this.state.loading} primary>
            Create!
          </Button>
        </Form>
        <Modal
        open={this.state.modalOpen}
        onClose={this.handleClose}
        basic
        size='small'
        >
          <Header icon='browser' content='Cookies policy' />
          <Modal.Content>
            <h3>Campaign Has Been Successfully Created</h3>
          </Modal.Content>
          <Modal.Actions>
            <Button color='green' onClick={this.handleClose} inverted>
              <Icon name='checkmark' /> Got it
            </Button>
          </Modal.Actions>
        </Modal>
      </Layout>
    );
  }
}

export default CampaignNew;
