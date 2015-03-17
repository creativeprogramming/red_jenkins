class TestcasesController < ApplicationController

    include TestcasesHelper

    def index
        @project = Project.find(params[:project_id])
        @testcases = Testcase.all

        # This variable is used to build the testcase tree
        @testcase_tree = {}
        # For each testcase t
        @testcases.each do |t|
            # add t to the tree
            add @testcase_tree, t.path.split("."), t
        end

        respond_to do |format|
            format.html
            format.json { render json: @testcase_tree }
        end

    end

    def show
        #leer
    end

    def new
        @testcase = Testcase.new
    end

    def edit
        @testcase = Testcase.find(params[:id])
    end

    def create
        testcase_input = testcase_params
        testcase_input["time_last_run"] = DateTime.now
        testcase_input["state"] = "UNKNOWN"
        testcase_input["test_type"] = "MANUAL"
        @testcase = Testcase.new(testcase_input)

        if @testcase.save
            redirect_to testcases_path
        else
            render 'new'
        end
    end

    def update
        @testcase = Testcase.find(params[:id])
        testcase_input = testcase_params
        testcase_input["time_last_run"] = DateTime.now
        testcase_input["test_type"] = "MANUAL"

        if @testcase.update(testcase_input)
            redirect_to testcases_path
        else
            render 'edit'
        end
    end

    def destroy
        @testcase = Testcase.find(params[:id])
        @testcase.destroy

        redirect_to testcases_path
    end

    private
    def testcase_params
        params.require(:testcase).permit(:name, :description, :path)
    end

end
