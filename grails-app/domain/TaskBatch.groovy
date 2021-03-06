
import com.tds.asset.Application
import com.tdsops.tm.enums.domain.ContextType
import com.tdssrc.grails.TimeUtil

/**
 * TaskBatch Domain Object
 * 
 * <p>Represents a batch that is created when a recipe is executed and tasks are generated. This will provide a way of tracking, updating and
 * possibly deleting tasks that were generate in the cookbook.
 *
 * @author John Martin
 */
class TaskBatch {

	ContextType contextType
	Integer contextId
	String status
	
	/** The recipeVersion that was used to generate the batch of tasks */
	RecipeVersion recipeVersionUsed
	/** Number of tasks that were generated by the process (static as tasks could be manually deleted). Default
		value (0) */
	Integer taskCount=0	
	/** Number of exceptions that occurred during the recipe generation. Actual exceptions are listed in the exceptionLog
		property. Default value (0). */
	Integer exceptionCount=0
	/** Flag indicating if the tasks generated where published to users. Default value (false) */
	Boolean isPublished = false
	/** List of the exceptions that were created by the generation of the batch */
	String exceptionLog = ''
	/** List of the debug log/info that were created by the generation of the batch */
	String infoLog = ''
	/** Whom created this version of the recipe */
	Person createdBy
	Project project

	Date dateCreated
	Date lastUpdated

	static constraints = {
		contextType(nullable:false)
		contextId(nullable:false)
		recipeVersionUsed(nullable:true)		// Note that recipes can be deleted which will null out any references
		taskCount(nullable:false)
		exceptionLog(blank:true, nullable:false)
		infoLog(blank:true, nullable:false)

		createdBy(nullable:false)
		dateCreated(nullable:true)
		lastUpdated(nullable:true)
		status(blank:false, nullable:false ,inList:['Pending', 'Generating', 'Completed', 'Cancelled'] )
	}

	static mapping  = {	
		version false
		autoTimestamp false
		id column: 'task_batch_id'
		contextId column: 'context_id'
		contextType column: 'context_type'
		columns {
			infoLog sqltype: 'text'
			exceptionLog sqltype: 'text'
			taskCount sqltype: 'smallint'
		}
	}
		
	def beforeInsert = {
		dateCreated = TimeUtil.nowGMT()
		lastUpdated = dateCreated
	}
	
	def beforeUpdate = {
		lastUpdated = TimeUtil.nowGMT()
	}

	/** 
	 * Used to get the name of the object for which the context references
	 */
	def contextName() {
		if (contextType == null) {
			return "";
		}
		switch (contextType) {
			case ContextType.A:
				Application o = Application.get(this.contextId)
				return o == null ? "" : o.assetName
				break;
			case ContextType.B:
				MoveBundle o = MoveBundle.get(this.contextId)
				return o == null ? "" : o.name
				break;
			case ContextType.E:
				MoveEvent o = MoveEvent.get(this.contextId)
				return o == null ? "" : o.name
				break;
			default:
				return ""
				break;
		}
	}

	/**
	 * Returns informational representation of the task formated as Context + Context Object + batch (# tasks) 
	 * (e.g. Application VSphere 5.0 Cluster - batch (30 tasks) )
	 * @return String
	 */
	String toString() {
		(recipeVersionUsed ? recipeVersionUsed.recipe.context.toString()+' ' : '' ) + contextName() + " - batch of ${taskCount} tasks" 
	}	
	
}